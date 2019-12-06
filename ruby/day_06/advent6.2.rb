#!/usr/bin/env ruby

require_relative "./advent6.1"

san = @com.find("SAN")
you = @com.find("YOU")

first_common = (san.parents.map(&:name) & you.parents.map(&:name)).first

p san.distance_to(first_common) + you.distance_to(first_common) - 2