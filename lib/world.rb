require_relative './world_objects'
require_relative './vector'

module SnakeGame
  class World
    attr_reader :world, :life, :food, :tunnels

    def initialize(width, world, food, tunnels)
      @world_size = width
      @world = world
			@food = food
			@tunnels = tunnels
    end

    def [](position)
      row, column = position.x, position.y
      @world[row][column]
    end

    def []=(position, value)
      row, column = position.x, position.y
      @world[row][column] = value
    end

    def size
      @world_size
    end

    def in_bounds?(position)
      if position.x >= 0 and position.x < @world_size and
          position.y >= 0 and position.y < @world_size
        true
      else
        false
      end
    end

    def update_food(food)
      number_of_new_food = food.set_food_count
      1.upto(number_of_new_food) do
        begin
          x = Random.rand(@world_size)
          y = Random.rand(@world_size)
        end while @world[x][y]

        coords = Vector.new(x,y)
        new_food = food.set_food(coords)
        @world[x][y] = new_food
        @food << new_food
      end
      food_index = @food.index(food)
      @food.delete_at(food_index)
    end

    def to_s
      output = ''
      @world.each.with_index do |row, i|
        row.each.with_index do |object, j|
          image = object ? object.image : '*'
          space = (j < row.size - 1) ? ' ' : ''
          output << image + space
        end
        output << "\n" if i < (@world.size - 1)
      end
      "#{output}"
    end

  end
end