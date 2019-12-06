#!/usr/bin/env ruby

# --- Day 6: Universal Orbit Map ---
#
# You've landed at the Universal Orbit Map facility on Mercury. Because navigation in space often involves transferring between orbits, the orbit maps here are useful for finding efficient routes between, for example, you and Santa. You download a map of the local orbits (your puzzle input).
#
# Except for the universal Center of Mass (COM), every object in space is in orbit around exactly one other object. An orbit looks roughly like this:
#
#                   \
#                    \
#                     |
#                     |
# AAA--> o            o <--BBB
#                     |
#                     |
#                    /
#                   /
#
# In this diagram, the object BBB is in orbit around AAA. The path that BBB takes around AAA (drawn with lines) is only partly shown. In the map data, this orbital relationship is written AAA)BBB, which means "BBB is in orbit around AAA".
#
# Before you use your map data to plot a course, you need to make sure it wasn't corrupted during the download. To verify maps, the Universal Orbit Map facility uses orbit count checksums - the total number of direct orbits (like the one shown above) and indirect orbits.
#
# Whenever A orbits B and B orbits C, then A indirectly orbits C. This chain can be any number of objects long: if A orbits B, B orbits C, and C orbits D, then A indirectly orbits D.
#
# For example, suppose you have the following map:
#
# COM)B
# B)C
# C)D
# D)E
# E)F
# B)G
# G)H
# D)I
# E)J
# J)K
# K)L
#
# Visually, the above map of orbits looks like this:
#
#         G - H       J - K - L
#        /           /
# COM - B - C - D - E - F
#                \
#                 I
#
# In this visual representation, when two objects are connected by a line, the one on the right directly orbits the one on the left.
#
# Here, we can count the total number of orbits as follows:
#
# D directly orbits C and indirectly orbits B and COM, a total of 3 orbits.
# L directly orbits K and indirectly orbits J, E, D, C, B, and COM, a total of 7 orbits.
# COM orbits nothing.
#
# The total number of direct and indirect orbits in this example is 42.
#
# What is the total number of direct and indirect orbits in your map data?

class Node
  attr_reader :name, :children, :depth, :parent

  def initialize(name, depth = 0, parent = nil)
    @name = name
    @depth = depth
    @parent = parent
    @children = []
  end

  def find(node_name)
    if node_name == name
      return self
    else
      children.map do |child|
        if res = child.find(node_name)
          return res
        end
      end.first
    end
  end

  def insert(new_name, parent_name, depth = 1)
    if parent_name == name
      add_child(Node.new(new_name, depth, self))
      true
    else
      children.map do |child|
        child.insert(new_name, parent_name, depth + 1)
      end.any?
    end
  end

  def add_child(node)
    @children << node
  end

  def total_depth
    children.sum do |node|
      node.total_depth
    end + depth
  end

  def parents
    return [] unless parent
    [parent] + parent.parents
  end

  def distance_to(parent_name)
    if parent.name == parent_name
      1
    else
      1 + parent.distance_to(parent_name)
    end
  end
end

data = STDIN.read.split.map { |entry| entry.split(")") }

@com = Node.new("COM")

# Build tree naively
loop do
  break if data.none?
  inserted = data.select do |parent_name, name|
    @com.insert(name, parent_name)
  end
  data = data - inserted
end

if __FILE__ == $0
  p @com.total_depth
end
