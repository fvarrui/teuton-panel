# frozen_string_literal: true

require_relative "version"
require_relative "runner"

module Teuton::Panel
  ##
  # Orders Teuton runs: teacher runs first and alone, student runs in
  # parallel up to max_parallel. Each job runs in its own thread.
  class RunQueue
    def initialize(max_parallel)
      @max_parallel = [max_parallel.to_i, 1].max
      @lock = Mutex.new
      @cv = ConditionVariable.new
      @waiting = []
      @running = []
      @dispatcher = Thread.new { dispatch }
    end

    ##
    # Queue a run
    # @param workspace (Workspace)
    # @param kind (String) full, selection or student
    # @param keys (Array|nil) tt_panel_key values (nil = all)
    # @param code (String|nil) Student code, for student runs
    # @param block Called with the run summary when finished
    # @return Hash job, or nil when that student already has a run queued
    def submit(workspace, kind, keys, code = nil, &block)
      @lock.synchronize do
        return nil if !code.nil? && busy_locked?(code)

        job = {kind: kind, workspace: workspace, keys: keys, code: code, done: Thread::Queue.new}
        job[:callback] = block
        job[:queued_at] = Time.now
        @waiting << job
        @cv.broadcast
        job
      end
    end

    def busy?(code)
      @lock.synchronize { busy_locked?(code) }
    end

    ##
    # True while a teacher run is waiting or running
    def teacher_busy?
      @lock.synchronize { (@waiting + @running).any? { teacher?(_1) } }
    end

    ##
    # @return Hash {running: [...], waiting: [...]} with kind and code
    def status
      @lock.synchronize do
        view = ->(job) { {kind: job[:kind], code: job[:code], since: job[:started_at] || job[:queued_at]} }
        {running: @running.map(&view), waiting: @waiting.map(&view)}
      end
    end

    ##
    # Drop waiting jobs and kill running Teuton processes
    def kill_all
      @lock.synchronize do
        @waiting.clear
        @running.each { _1[:runner]&.kill }
      end
    end

    def to_s
      "RunQueue: max #{@max_parallel}"
    end

    private

    def teacher?(job)
      job[:kind] != "student"
    end

    def busy_locked?(code)
      (@waiting + @running).any? { _1[:code] == code }
    end

    def dispatch
      loop do
        job = nil
        @lock.synchronize do
          job = next_job
          while job.nil?
            @cv.wait(@lock)
            job = next_job
          end
          @waiting.delete(job)
          @running << job
          job[:started_at] = Time.now
          job[:runner] = Runner.new(job[:workspace])
        end
        Thread.new(job) { execute(_1) }
      end
    end

    def next_job
      teacher = @waiting.find { teacher?(_1) }
      return (@running.empty? ? teacher : nil) unless teacher.nil?
      return nil if @running.any? { teacher?(_1) } || @running.size >= @max_parallel

      @waiting.first
    end

    def execute(job)
      summary = nil
      begin
        summary = job[:runner].call(job[:kind], job[:keys])
        job[:callback]&.call(summary)
      rescue => e
        warn "[ERROR] RunQueue.execute: #{e}"
      ensure
        @lock.synchronize do
          @running.delete(job)
          @cv.broadcast
        end
        job[:done] << summary
      end
    end
  end
end
