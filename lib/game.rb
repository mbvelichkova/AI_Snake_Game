require_relative './world'
require_relative './io_parser'
require_relative './snake'
require_relative './vector'
require_relative './config_file'
require_relative './ai_movement'

module SnakeGame
  class Game  
    attr_accessor :snakes, :world, :score, :level , :ai #for test
  
    def initialize(load_file = nil, score = 0, level = 1)
      @score, @level = score, level
      map = IO.new
      filename = load_file ? load_file : Configuration::FILE[level]
      map.read_file(filename)
			
      @world = World.new(map.world_size, map.world, map.food, map.tunnels)
			
			@snakes = {}
			map.snakes.each_with_index do |snake_info, player|
				puts snake_info[":lives"]
				snake = Snake.new(@world, snake_info[:lives], snake_info[:score], snake_info[:snake_head], snake_info[:snake_body], Vector.new(0,1))
				@snakes[player] =  snake
			end
    end
		def test
			@map.snakes
		end
		
		def play_user
			init_ai
			while @snakes[1].energy < 4
				play_with_ai(@snakes[1])
				play_with_ai(@snakes[0])
			end
		end
  
    def move(snake, position)
      snake.move(position)
      update_game
      puts 'Score: ' + snake.energy.to_s
      puts 'Lives:' + snake.lives.to_s
      puts @world
    end
    
    def update_game
			@snakes.each do |player, snake|
				if snake.dead?
					puts 'Game over!'
					puts 'Player ' + player.to_s + ' is dead.'
				elsif snake.energy == Configuration::SCORE_LEVEL[1]
					puts 'Next level!'
					Game.new(Configuration::FILE[level+1], snake.energy, level+1) 
				elsif snake.energy == Configuration::SCORE_LEVEL[1]
					puts 'Player ' + player.to_s + ' wins!'
				end  
			end
    end
    
		#TODO: not actual
    def save_game(filename)
      map = IO.new
      map.write_file(filename, @world.world, @score, @snake.lives, @snake.direction, @snake.head, @snake.body)
    end
		
		def init_ai
			@ai = AStar.new(@world, @world.food[0].coords)
		end
		
		def play_with_ai(snake)		
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
