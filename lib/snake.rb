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
      if direction.opposite_direction(@direction)
				puts'Opposite direction move is not allowed!'
				return
      end

      @direction = direction
      new_position = @head + direction
			
      if not @world.in_bounds?(new_position)
        puts'You are out of bounds!' 
				return
      end
			
      object = @world[new_position]
			move_over_tunnel = object.is_a? Tunnel
      case object
        when Food
          eat_food(object)
          move_snake_body(new_position, false, move_over_tunnel)
        when Wall, SnakePart
          lose_life
        else
          move_snake_body(new_position, true, move_over_tunnel)
      end
			nil
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

    def move_snake_body(position, free_last, move_over_tunnel)
      place_snake_head(position, move_over_tunnel)
      if free_last
        last = @body.pop
        @world[last] = nil
      end
    end

    # First mark as snake part the position where
    # the head is, and then move the head.
    def place_snake_head(position, move_over_tunnel)
      snake_part = SnakePart.new(@head)
      @world[@head] = snake_part
      @head = position
      @world[position] = SnakeHead.new(position)
			@world[position].set_over_tunnel(move_over_tunnel)
      @body.unshift @head
    end
  end
end