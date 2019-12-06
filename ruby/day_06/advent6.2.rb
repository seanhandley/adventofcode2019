#!/usr/bin/env ruby

require_relative "./advent6.1"

san = Tree.instance.find("SAN")
you = Tree.instance.find("YOU")

first_common = [san, you].map { |node| node.parents.map(&:name) }.reduce(:&).first

p [san, you].sum { |node| node.distance_to(first_common) } - 2
