#!/usr/bin/env ruby

SIZE = 10006

@cards = (0..SIZE).to_a
@new_deck = @cards.dup
@instructions = STDIN.read.split("\n")

def deal_with_increment(increment)
  @cards.each_with_index do |card, i|
    @new_deck[i * increment % @cards.length] = card
  end
  @cards = @new_deck.dup
end

@instructions.each do |instruction|
  if instruction == "deal into new stack"
    @cards.reverse!
  elsif instruction.start_with?("cut")
    @cards.rotate! instruction.match(/-?\d+/)[0].to_i
  else
    deal_with_increment instruction.match(/\d+/)[0].to_i
  end
end

puts @cards.index(2019)
