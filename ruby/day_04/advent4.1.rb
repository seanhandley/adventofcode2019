#!/usr/bin/env ruby

class PasswordValidator
  attr_reader :range

  def initialize(input, rules = nil)
    @range = Range.new(*input.split("-"))
    @rules = Rules.new(rules)
  end

  def add_rule(rule)
    @rules.add(rule)
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

if __FILE__ == $0
  p PasswordValidator.new(STDIN.read).valid_password_count
end
