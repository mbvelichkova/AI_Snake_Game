require_relative './vector'
require_relative './world_objects'

module SnakeGame
  class IO
    attr_reader :world_size, :world, :tunnels, :food, :snakes

    def initialize
			@snakes = []
    end

    def read_file(filename)
      file = File.absolute_path("../data/#{filename}")
      if not File.exist?(file)
        raise IOError, "File doesn't exist"
        return
      end
			if not File.readable?(file)
        raise IOError, "File is not readable"
        return
      end
      begin
				input = File.read(file)
				categories = input.split("##")
      rescue IOError
        "Could not read from file"
      end
			
			categories.each do |category|
					transform_snake_info(category) if /\A\d+/.match(category)
			end
			transform_map_info(categories[categories.size-1])
    end

		#TODO: to be add func for more than one snake
    def write_file(filename, world, score, lives, direction, snake_head, snake_body, tunnels)
      output = File.open("..//data//" + filename, "w")
			output.write("#Score" + "\n")
      output.write(score.to_s + "\n")
			
			output.write("#Lives" + "\n")
      output.write(lives.to_s + "\n")
			
			output.write("#Direction" + "\n")
      output.write(direction.to_s + "\n")
			
			output.write("#Snake Head" + "\n")
      output.write(snake_head.to_s + "\n")
			
			output.write("#Snake Body" + "\n")
      snake_body.each do |snake_part|
        output.write(snake_part.to_s + "; ")
      end
      output.write("\n")
			
			output.write("#Tunnels" + "\n")
			tunnels.each_value do |info|
				start = info.start.to_s
				exit = info.exit.to_s
				output.write(start + "; " + exit + "\n")
			end
			
			output.write("#Map" + "\n")
      world.each.with_index do |row, i|
        row.each.with_index do |object, j|
          image = object ? object.image : '*'
          image << " " if j < (row.size - 1)
          begin
            output.write(image)
          rescue IOError
            "Could not write to file"
          end
        end
        output.write("\n") if i < (world.size - 1)
      end
      output.close
    end

    private
		def transform_snake_info(snakes_info)
			info = snakes_info.split("#")
			direction, snake_head_coords, snake_body_coords = "", "", ""
			score, lives = 0, 0
			info.each do |category|
				case category
				when /\AScore/
					score = category.split("\n")[1]
				when /\ALives/
					lives = category.split("\n")[1]
				when /\ADirection/
					direction = category.split("\n")[1]
				when /\ASnake Head/
					snake_head_coords = category.split("\n")[1]
				when /\ASnake Body/
					snake_body_coords = category.split("\n")[1]
				end
			end
			initialize_snake_info(score, lives, direction, snake_head_coords, snake_body_coords)
		end
		
		def transform_map_info(info)
			categories = info.split("#")
			tunnels_arr, map= [], []
			categories.each do |category|
				case category
				when /\ATunnels/
					end_index = category.size
					tunnels_arr = category.split("\n")[1..end_index]
				when /\AMap/
					end_index = category.size
					map = category.split("\n")[1..end_index].map{ |s| s.split }
					@world_size = map.size
				end
			end
			initialize_tunnels(tunnels_arr)
			initialize_world(map)
		end

		def initialize_tunnels(tunnels)
			@tunnels = {}
			tunnels.each do |tunnel|
				start_str, exit_str = tunnel.split(";")
				
				start_coords = start_str.match(/(?<x>[0-9]+), (?<y>[0-9]+)/)
				exit_coords = exit_str.match(/(?<x>[0-9]+), (?<y>[0-9]+)/)

				start = Vector.new(start_coords[:x].to_i, start_coords[:y].to_i) if start_coords
				exit = Vector.new(exit_coords[:x].to_i, exit_coords[:y].to_i) if exit_coords

				@tunnels[start] = Tunnel.new(start, exit)
			end
		end
		
    def initialize_snake_info(score, lives, direction, snake_head_coords, snake_body_coords)
			snake_info = {}
			snake_body = []
			
			snake_info[:score] = score.to_i
			snake_info[:lives] = lives.to_i
			
      coords = direction.match(/(?<x>[0-9]+), (?<y>[0-9]+)/)
      direction = Vector.new(coords[:x].to_i, coords[:y].to_i) if coords
			snake_info[:direction] = direction
			
      coords = snake_head_coords.match(/(?<x>[0-9]+), (?<y>[0-9]+)/)
      snake_head = Vector.new(coords[:x].to_i, coords[:y].to_i) if coords
			snake_info[:snake_head] = snake_head
			
      snake_body_coords.split(';').each do |pair|
        coords = pair.match(/(?<x>[0-9]+), (?<y>[0-9]+)/)
        snake_body << Vector.new(coords[:x].to_i, coords[:y].to_i) if coords
      end
			snake_info[:snake_body] = snake_body
			
			@snakes << snake_info
    end
		
		def initialize_world(map)
      @world = Array.new(@world_size) { Array.new(@world_size) }
      @food = []
      map.each.with_index do |row, i|
        row.each.with_index do |object, j|
          if object == '*'
            @world[i][j] = nil
          elsif object == 'O'
            ordinary_food = OrdinaryFood.new(Vector.new(i, j))
            @world[i][j] = ordinary_food
            @food << ordinary_food
          elsif object == 'W'
            @world[i][j] = Wall.new(Vector.new(i, j))
          elsif object == 'P'
            snake_part = SnakePart.new(Vector.new(i, j))
            @world[i][j] = snake_part
          elsif object == 'H'
            snake_head = SnakeHead.new(Vector.new(i, j))
            @world[i][j] = snake_head
          elsif object == 'T'
						tunnel = @tunnels[Vector.new(i, j)]
            @world[i][j] = tunnel
          end
        end
      end
    end
  end
end