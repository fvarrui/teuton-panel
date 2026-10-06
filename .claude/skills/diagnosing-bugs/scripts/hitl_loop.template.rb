# frozen_string_literal: true

# Human-in-the-loop reproduction loop (Ruby port of hitl-loop.template.sh).
# Copy this file, edit the steps below, and run it.
# The agent runs the script; the user follows prompts in their terminal.
#
# Usage:
#   ruby hitl_loop.template.rb
#
# Two helpers:
#   step "<instruction>"          -> show instruction, wait for Enter
#   capture :var, "<question>"    -> show question, read the answer into var
#
# At the end, captured values are printed as KEY=VALUE for the agent to parse.
#
# `capture` prints its value back to the terminal, where the agent reads it,
# so capture observations, and leave signing in to the user as a `step`.

CAPTURED = {}

def step(instruction)
  puts "\n>>> #{instruction}"
  print "    [Enter when done] "
  $stdin.gets
end

def capture(name, question)
  puts "\n>>> #{question}"
  print "    > "
  CAPTURED[name] = $stdin.gets.to_s.chomp
end

# --- edit below ---------------------------------------------------------

step "Open the panel at http://localhost:4567/teacher and check the active test."

capture :errored, "Click 'Start' on the Run page. Did it show an error? (y/n)"

capture :error_msg, "Paste the error message (or 'none'):"

# --- edit above ---------------------------------------------------------

puts "\n--- Captured ---"
CAPTURED.each { |key, value| puts "#{key.to_s.upcase}=#{value}" }
