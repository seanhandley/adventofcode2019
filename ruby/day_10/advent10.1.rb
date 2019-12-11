#!/usr/bin/env ruby

@asteroids = STDIN.read.split.map(&:chars)

@asteroids.each_with_index do |row, y|
  row.each_with_index do |col, x|
    if @asteroids[y][x] == "#"
      @asteroids[y][x] = [[y,x]]
    end
  end
end

def path_contents(origin, asteroid)
  x1, y1 = origin
  x2, y2 = asteroid

  steep = (y2 - y1).abs > (x2 - x1).abs

  if steep
    x1, y1 = y1, x1
    x2, y2 = y2, x2
  end

  if x1 > x2
    x1, x2 = x2, x1
    y1, y2 = y2, y1
  end

  deltax = x2 - x1
  deltay = (y2 - y1).abs
  error = deltax / 2
  ystep = y1 < y2 ? 1 : -1

  y = y1
  line = []
  x1.upto(x2) do |x|
    if steep
      line << [y, x] unless @asteroids[x][y] == "."
    else
      line << [x, y] unless @asteroids[y][x] == "."
    end
    error -= deltay
    if error < 0
      y += ystep
      error += deltax
    end
  end
  line - [origin]
end

def nearest(origin, line)
  line.min_by { |el| (el[0] - origin[0]).abs + (el[1] - origin[1]).abs }
end

@asteroids.each_with_index do |row, y|
  row.each_with_index do |col, x|
    next if @asteroids[y][x] == "."
    @asteroids.each_with_index do |rowr, yy|
      rowr.each_with_index do |colc, xx|
        next if @asteroids[yy][xx] == "."
        line = path_contents([x,y], [xx,yy])
        nearest = nearest([x,y], line)
        next unless asteroid = nearest([x,y], line)

        @asteroids[y][x] = @asteroids[y][x] + [asteroid.dup]
        @asteroids[y][x].uniq!
      end
    end
  end
end

counts = @asteroids.map do |row|
  row.reject { |el| el == "." }.map do |col|
    col.count
  end
end.flatten

p counts.max
