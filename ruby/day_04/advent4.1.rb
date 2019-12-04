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

  def initialize(start, stop, rules = nil)
    @range = Range.new(start, stop)
    @rules = Rules.new(rules)
  end

  def add_rule(rule)
    @rules.add(rule)
    self
  end

  def valid_password_count
    range.select(&method(:valid?)).count
  end

  def valid?(password)
    @rules.valid?(password)
  end

  class Rules
    DEFAULT_RULES = [
      -> (password) do
        repeating = false
        password.chars.each_cons(2) do |a, b|
          repeating = true if a == b
          return false if a > b
        end
        return false unless repeating
        true
      end
    ]

    def initialize(rules = nil)
      @rules = rules || DEFAULT_RULES
    end

    def add(rule)
      @rules << rule
    end

    def valid?(password)
      @rules.all? { |rule| rule.(password) }
    end
  end
end

INPUT = STDIN.read.split("-").freeze

if __FILE__ == $0
  p PasswordValidator.new(*INPUT).valid_password_count
end
