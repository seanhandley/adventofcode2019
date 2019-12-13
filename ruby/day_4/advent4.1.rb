#!/usr/bin/env ruby

# --- Day 4: Secure Container ---
#
# You arrive at the Venus fuel depot only to discover it's protected by a password. The Elves had written the password on a sticky note, but someone threw it out.
#
# However, they do remember a few key facts about the password:
#
# It is a six-digit number.
# The value is within the range given in your puzzle input.
# Two adjacent digits are the same (like 22 in 122345).
# Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
#
# Other than the range rule, the following are true:
#
# 111111 meets these criteria (double 11, never decreases).
# 223450 does not meet these criteria (decreasing pair of digits 50).
# 123789 does not meet these criteria (no double).
#
# How many different passwords within the range given in your puzzle input meet these criteria?
class PasswordValidator
  attr_reader :range

  def initialize(start, stop)
    @range = Range.new(start, stop)
    @rules = Array.new
  end

  def add_rule(rule)
    @rules.append(rule)
    self
  end

  def valid_password_count
    range.count(&method(:valid?))
  end

  def valid?(password)
    @rules.all? { |rule| rule.(password.chars) }
  end
end

no_decreasing_digits = -> (password) do
  # Ensure there are no sequences of decreasing digits
  password.slice_when { |a, b| a <= b }.count == password.length
end

repeating_digits = -> (password) do
  # Ensure there is at least one contiguous repeating digit
  password.slice_when { |a, b| a != b }.count < password.length
end

@pv = PasswordValidator.new(*STDIN.read.split("-")).
  add_rule(no_decreasing_digits).
  add_rule(repeating_digits)

if __FILE__ == $0
  p @pv.valid_password_count
end
