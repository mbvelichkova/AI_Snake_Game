require_relative './world'
require_relative './io_parser'
require_relative './snake'
require_relative './vector'
require_relative './config_file'
require_relative './ai_movement'

module SnakeGame
  class Game  
    attr_accessor :snake, :world, :score, :level , :ai #for test
  
    def initialize(load_file = nil, score = 0, level = 1)
      @score, @level = score, level
      map = IO.new
      filename = load_file ? load_file : Configuration::FILE[level]
      map.read_file(filename)
      @world = World.new(map.world_size, map.world, map.food, map.tunnels)
      @snake = Snake.new(@world, map.lives, map.score, map.snake_head, map.snake_body, Vector.new(0,1))
    end
  
    def move(position)
      @snake.move(position)
      update_game
      puts 'Score: ' + @score.to_s
      puts 'Lives:' + @snake.lives.to_s
      puts @world
    end
    
    def update_game
      @score = @snake.energy
      if @snake.dead?
        puts 'Game over!'
      elsif @snake.energy == Configuration::SCORE_LEVEL[1]
        puts 'Next level!'
        Game.new(Configuration::FILE[level+1], @score, level+1) 
      elsif @snake.energy == Configuration::SCORE_LEVEL[1]
        puts 'You win!'
      end  
    end
    
    def save_game(filename)
      map = IO.new
      map.write_file(filename, @world.world, @score, @snake.lives, @snake.direction, @snake.head, @snake.body)
    end
		
		def init_ai
			@ai = AStar.new(@world, @world.food[0].coords)
		end
		
		def play_with_ai		
			new_position = @ai.a_star(@snake.head)
			move(new_position)
		end
  end
end
