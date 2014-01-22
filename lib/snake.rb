require_relative './world_objects'
require_relative './world'

module SnakeGame
  class Snake
    attr_accessor :energy, :lives, :world, :body, :head, :direction

    def initialize(world, lives, energy, head, body, direction)
      @world = world
      @lives = lives
      @energy = energy
      @head = head
      @body = body
      @direction = direction
    end

    def move(position)
			direction = position - @head 
			puts "dir: "
			puts direction
			puts position
      if direction.opposite_direction(@direction)
        puts 'Opposite direction move is not allowed!'
        return
      end

      @direction = direction
      new_position = @head + direction
			
			puts "new dir: "
			puts @direction
			puts new_position
      if not @world.in_bounds?(new_position)
        puts 'You are out of bounds!'
        return
      end

      object = @world[new_position]
      case object
        when Food
          eat_food(object)
          move_snake_body(new_position, false)
        when Wall, SnakePart
          lose_life
        else
          move_snake_body(new_position, true)
      end
    end

    def eat_food(food)
      @energy = @energy + food.energy
      @world.update_food(food)
    end

    def lose_life
      @lives = @lives - 1
    end

    def dead?
      @lives == 0
    end

    private

    def move_snake_body(position, free_last)
      place_snake_head(position)
      if free_last
        last = @body.pop
        @world[last] = nil
      end
    end

    # First mark as snake part the position where
    # the head is, and then move the head.
    def place_snake_head(position)
      snake_part = SnakePart.new(@head)
      @world[@head] = snake_part
      @head = position
      @world[position] = SnakeHead.new(position)
      @body.unshift @head
    end
  end
end