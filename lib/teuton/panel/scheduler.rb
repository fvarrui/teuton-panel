# frozen_string_literal: true

require_relative "version"

module Teuton::Panel
  ##
  # Teacher runs: once, N times or every T seconds (optionally until a time)
  class Scheduler
    MODES = %w[once times every]

    attr_reader :settings

    ##
    # @param queue (RunQueue)
    def initialize(queue)
      @queue = queue
      @lock = Mutex.new
      @thread = nil
      @settings = nil # Last started settings
      @state = idle
    end

    ##
    # Start teacher runs (stops the current ones first)
    # @param workspace (Workspace)
    # @param args (Hash) mode:, times:, every:, delay:, keys:, until_time:
    # @param block Called with each run summary
    def start(workspace, args, &block)
      stop
      @lock.synchronize do
        @settings = args
        @state = {active: true, mode: args[:mode], pass: 0, next_at: Time.now, last_run: nil}
        @thread = Thread.new { loop_runs(workspace, args, block) }
      end
    end

    def stop
      thread = nil
      @lock.synchronize do
        thread = @thread
        @thread = nil
        @state = idle.merge(last_run: @state[:last_run])
      end
      return if thread.nil?

      @queue.kill_all
      thread.kill
    end

    def active?
      @lock.synchronize { @state[:active] }
    end

    ##
    # @return Hash active:, mode:, pass:, next_at:, last_run:
    def status
      @lock.synchronize { @state.dup }
    end

    def to_s
      "Scheduler: #{@state[:mode] || "idle"}"
    end

    private

    def idle
      {active: false, mode: nil, pass: 0, next_at: nil, last_run: nil}
    end

    def loop_runs(workspace, args, block)
      passes = passes_for(args)
      pass = 0
      loop do
        pass += 1
        started = Time.now
        set_state(pass: pass, next_at: nil)
        kind = args[:keys].nil? ? "full" : "selection"
        job = @queue.submit(workspace, kind, args[:keys], &block)
        summary = job[:done].pop
        break if !passes.nil? && pass >= passes

        wait = (args[:mode] == "every") ? args[:every].to_i - (Time.now - started) : args[:delay].to_i
        next_at = Time.now + [wait, 0].max
        break if !args[:until_time].nil? && next_at > args[:until_time]

        set_state(next_at: next_at, last_run: summary && summary["id"])
        sleep [wait, 0].max
      end
      @lock.synchronize { @state = idle.merge(last_run: @state[:last_run], pass: pass) }
    end

    def passes_for(args)
      return 1 if args[:mode] == "once"
      return [args[:times].to_i, 1].max if args[:mode] == "times"

      nil
    end

    def set_state(values)
      @lock.synchronize { @state = @state.merge(values) }
    end
  end
end
