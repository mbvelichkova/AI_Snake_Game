require_relative './world'
require_relative './io_parser'
require_relative './snake'
require_relative './vector'
require_relative './config_file'
require_relative './ai_movement'

module SnakeGame
  class Game  
    attr_accessor :snakes, :world,  :ai #for test
  
    def initialize(load_file = nil, win_score = 15, level = 1)
      @level, @win_score =  level, win_score
      map = IO.new
      filename = load_file ? load_file : Configuration::FILE[level]
      map.read_file(filename)
			
      @world = World.new(map.world_size, map.world, map.food, map.tunnels)
			
			@snakes = {}
			map.snakes.each_with_index do |snake_info, player|
				snake = Snake.new(@world, snake_info[:lives], snake_info[:score], snake_info[:snake_head], snake_info[:snake_body], snake_info[:direction])
				@snakes[player] =  snake
			end
    end
		
    def move(snake, position)
      snake.move(position)
    end
		
		#TODO: not actual
    def save_game(filename)
      map = IO.new
      map.write_file(filename, @world.world, @score, @snake.lives, @snake.direction, @snake.head, @snake.body)
    end
		
		def init_ai
			@ai = AStar.new(@world, @world.food[0].coords)
		end
		
		def move_with_ai(snake)		
			new_position = @ai.a_star(snake.head)
			if new_position
				move(snake, new_position)
			else
				@ai = AStar.new(@world, @world.food[0].coords)
				new_position = @ai.a_star(snake.head)
				move(snake, new_position) if new_position
			end
		end
  end
end
