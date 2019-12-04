#!/usr/bin/env ruby

# --- Part Two ---
#
# An Elf just remembered one more important detail: the two adjacent matching digits are not part of a larger group of matching digits.
#
# Given this additional criterion, but still ignoring the range rule, the following are now true:
#
# 112233 meets these criteria because the digits never decrease and all repeated digits are exactly two digits long.
# 123444 no longer meets the criteria (the repeated 44 is part of a larger group of 444).
# 111122 meets the criteria (even though 1 is repeated more than twice, it still contains a double 22).
#
# How many different passwords within the range given in your puzzle input meet all of the criteria?

require_relative "./advent4.1"

runs = -> (password) do
  password.chars.each_with_object([[]]) do |char, runs|
    run = runs.last
    if run.empty? || run.include?(char)
      run.append(char)
    else
      runs.append([char])
    end
  end.any? { |run| run.count == 2 }
end

p PasswordValidator.new(*INPUT).add_rule(runs).valid_password_count
