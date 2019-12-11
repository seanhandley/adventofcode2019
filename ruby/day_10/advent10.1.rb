#!/usr/bin/env ruby

# --- Day 10: Monitoring Station ---
#
# You fly into the asteroid belt and reach the Ceres monitoring station. The Elves here have an emergency: they're having trouble tracking all of the asteroids and can't be sure they're safe.
#
# The Elves would like to build a new monitoring station in a nearby area of space; they hand you a map of all of the asteroids in that region (your puzzle input).
#
# The map indicates whether each position is empty (.) or contains an asteroid (#). The asteroids are much smaller than they appear on the map, and every asteroid is exactly in the center of its marked position. The asteroids can be described with X,Y coordinates where X is the distance from the left edge and Y is the distance from the top edge (so the top-left corner is 0,0 and the position immediately to its right is 1,0).
#
# Your job is to figure out which asteroid would be the best place to build a new monitoring station. A monitoring station can detect any asteroid to which it has direct line of sight - that is, there cannot be another asteroid exactly between them. This line of sight can be at any angle, not just lines aligned to the grid or diagonally. The best location is the asteroid that can detect the largest number of other asteroids.
#
# For example, consider the following map:
#
# .#..#
# .....
# #####
# ....#
# ...##
#
# The best location for a new monitoring station on this map is the highlighted asteroid at 3,4 because it can detect 8 asteroids, more than any other location. (The only asteroid it cannot detect is the one at 1,0; its view of this asteroid is blocked by the asteroid at 2,2.) All other asteroids are worse locations; they can detect 7 or fewer other asteroids. Here is the number of other asteroids a monitoring station on each asteroid could detect:
#
# .7..7
# .....
# 67775
# ....7
# ...87
#
# Here is an asteroid (#) and some examples of the ways its line of sight might be blocked. If there were another asteroid at the location of a capital letter, the locations marked with the corresponding lowercase letter would be blocked and could not be detected:
#
# #.........
# ...A......
# ...B..a...
# .EDCG....a
# ..F.c.b...
# .....c....
# ..efd.c.gb
# .......c..
# ....f...c.
# ...e..d..c
#
# Here are some larger examples:
#
# Best is 5,8 with 33 other asteroids detected:
#
# ......#.#.
# #..#.#....
# ..#######.
# .#.#.###..
# .#..#.....
# ..#....#.#
# #..#....#.
# .##.#..###
# ##...#..#.
# .#....####
#
# Best is 1,2 with 35 other asteroids detected:
#
# #.#...#.#.
# .###....#.
# .#....#...
# ##.#.#.#.#
# ....#.#.#.
# .##..###.#
# ..#...##..
# ..##....##
# ......#...
# .####.###.
#
# Best is 6,3 with 41 other asteroids detected:
#
# .#..#..###
# ####.###.#
# ....###.#.
# ..###.##.#
# ##.##.#.#.
# ....###..#
# ..#.#..#.#
# #..#.#.###
# .##...##.#
# .....#.#..
#
# Best is 11,13 with 210 other asteroids detected:
#
# .#..##.###...#######
# ##.############..##.
# .#.######.########.#
# .###.#######.####.#.
# #####.##.#.##.###.##
# ..#####..#.#########
# ####################
# #.####....###.#.#.##
# ##.#################
# #####.##.###..####..
# ..######..##.#######
# ####.##.####...##..#
# .#####..#.######.###
# ##...#.##########...
# #.##########.#######
# .####.#.###.###.#.##
# ....##.##.###..#####
# .#.#.###########.###
# #.#.#.#####.####.###
# ###.##.####.##.#..##
#
# Find the best location for a new monitoring station. How many other asteroids can be detected from that location?

def asteroids
  @asteroids ||= STDIN.read.
    each_line.
    with_index.
    flat_map do |line, linenum|
      line.each_char.
        with_index.
        flat_map do |char, charnum|
          char == '#' ?  [[charnum, linenum]] : []
        end
    end
end

def angle_between(x1, y1, x2, y2)
  Math.atan2(x2 - x1, -(y2 - y1)) % (2 * Math::PI)
end

def distance_between(x1, y1, x2, y2)
  Math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2)
end

def asteroids_with_lines_of_sight
  asteroids.map do |asteroid|
    others = asteroids - asteroid
    lines = others.group_by { |other| angle_between(*asteroid, *other) }
    [asteroid, lines]
  end
end

def best_asteroid_with_lines_of_sight
  asteroids_with_lines_of_sight.max_by { |_, lines| lines.size }
end

if __FILE__ == $0
  _asteroid, lines_of_sight = best_asteroid_with_lines_of_sight
  p lines_of_sight.count
end
