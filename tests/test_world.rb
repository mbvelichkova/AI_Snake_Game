gem "minitest"
require 'minitest/autorun'
require '../lib/vector'
require '../lib/world_objects'
require '../lib/world'
module SnakeGame
  MAP = [['*', 'S', '*', 'W', '*'],
        ['*', '*', '*', 'W', '*'],
        ['*', '*', '*', '*', 'L'],
        ['P', 'H', '*', '*', '*'],
        ['*', '*', '*', '*', 'O']]
  SIZE = 5
  TIME_TO_APPEAR_NEW_LIFE = 10
  
  class WorldTest < MiniTest::Unit::TestCase
    def setup
      @world = World.new(SIZE, MAP, TIME_TO_APPEAR_NEW_LIFE)
    end
  
    def test_initialize_world
      assert_instance_of SnakeHead, @world[Vector.new(3, 1)]
      assert_instance_of SnakePart, @world[Vector.new(3, 0)]
      assert_instance_of Wall, @world[Vector.new(0, 3)]
      assert_instance_of SuperFood, @world[Vector.new(0, 1)]
      assert_instance_of OrdinaryFood, @world[Vector.new(4, 4)]
      assert_instance_of Life, @world[Vector.new(2, 4)]
    end                  
  
    def test_in_bounds?
      assert_equal true, @world.in_bounds?(Vector.new(3, 4))
      assert_equal true, @world.in_bounds?(Vector.new(0, 4))
      assert_equal false, @world.in_bounds?(Vector.new(-3, 4))
      assert_equal false, @world.in_bounds?(Vector.new(0, -2))
    end
  
    def test_size
      assert_equal SIZE, @world.size
    end
  
    def test_update_food_lives
      @world.update_food_lives
      assert_equal 14, @world[Vector.new(4, 4)].lives
      assert_equal 9, @world[Vector.new(0, 1)].lives
    end
    
    def test_eat_life
      @world.eat_life
      assert_equal nil, @world.life
    end
    
    def test_update_life_lives
      @world.update_life_lives
      assert_equal 16, @world[Vector.new(2, 4)].lives
    end
    
    def test_access_world
      assert_instance_of SnakePart, @world[Vector.new(3, 0)]
    end
    
    def test_access_world
      @world[Vector.new(0, 0)] = Wall.new(Vector.new(0, 0))
      assert_instance_of Wall, @world[Vector.new(0, 0)]
    end  end
end