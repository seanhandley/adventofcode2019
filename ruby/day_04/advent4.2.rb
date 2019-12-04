#!/usr/bin/env ruby

require_relative "./advent4.1"

runs = -> (password) do
  runs = []
  run = []
  password.to_s.chars.each do |c|
    if run.empty? || run.include?(c)
      run << c
    else
      runs << run
      run = [c]
    end
  end
  runs << run
  runs.map(&:count).any? { |count| count == 2 }
end

pv = PasswordValidator.new(STDIN.read)
pv.add_rule(runs)
p pv.valid_password_count
