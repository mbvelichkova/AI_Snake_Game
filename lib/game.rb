require_relative './world'
require_relative './io_parser'
require_relative './snake'
require_relative './vector'
require_relative './config_file'

module SnakeGame
  class Game  
    attr_accessor :snake, :world, :score, :level
  
    def initialize(load_file = nil, score = 0, level = 1)
      @score, @level = score, level
      map = IO.new
      filename = load_file ? load_file : Configuration::FILE[level]
      map.read_file(filename)
      @world = World.new(map.world_size, map.file_map, Configuration::TIME_TO_NEW_LIFE[level])
      @snake = Snake.new(@world, map.lives, map.score, map.snake_head, map.snake_body, Vector.new(0,1))
    end
  
    def move(direction)
      @snake.move(direction)
      @snake.world.update
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
  end
end
