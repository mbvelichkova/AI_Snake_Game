require_relative './vector'

module SnakeGame
  class IO
    attr_reader :score, :lives, :direction, :snake_head, :snake_body, :world_size, :file_map

    def initialize
      @score = 0
      @lives = 0
      @direction = nil
      @snake_head = nil
      @snake_body = []
    end

    def read_file(filename)
      file = File.absolute_path("../data/#{filename}")
      if not File.exist?(file)
        raise IOError, "File doesn't exist"
        return
      end
      begin
        input = File.open(file)
        score, lives, direction, snake_head_coords, snake_body_coords, *@file_map = input.each_line.map { |s| s }
        input.close
      rescue IOError
        puts "Could not read from file"
      end
      @file_map = @file_map.map{ |s| s.split }
      @world_size = @file_map.size
      initialize_setting(score, lives)
      initialize_snake_body_coords(direction, snake_head_coords, snake_body_coords)
    end

    def write_file(filename, world, score, lives, direction, snake_head, snake_body)
      output = File.open("..//data//" + filename, "w")
      output.write(score.to_s + "\n")
      output.write(lives.to_s + "\n")

      output.write(direction.to_s + "\n")
      output.write(snake_head.to_s + "\n")

      snake_body.each do |snake_part|
        output.write(snake_part.to_s + "; ")
      end
      output.write("\n")

      world.each.with_index do |row, i|
        row.each.with_index do |object, j|
          image = object ? object.image : '*'
          image << " " if j < (row.size - 1)
          begin
            output.write(image)
          rescue IOError
            puts "Could not write to file"
          end
        end
        output.write("\n") if i < (world.size - 1)
      end
      output.close
    end

    private

    def initialize_setting(score, lives)
      @score = score.to_i
      @lives = lives.to_i
    end

    def initialize_snake_body_coords(direction, snake_head_coords, snake_body_coords)
      coords = direction.match(/(?<x>[0-9]+), (?<y>[0-9]+)/)
      @direction = Vector.new(coords[:x].to_i, coords[:y].to_i) if coords

      coords = snake_head_coords.match(/(?<x>[0-9]+), (?<y>[0-9]+)/)
      @snake_head = Vector.new(coords[:x].to_i, coords[:y].to_i) if coords

      snake_body_coords.split(';').each do |pair|
        coords = pair.match(/(?<x>[0-9]+), (?<y>[0-9]+)/)
        @snake_body << Vector.new(coords[:x].to_i, coords[:y].to_i) if coords
      end
    end
  end
end