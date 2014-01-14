gem "minitest"
require 'minitest/autorun'
require_relative '../lib/vector'
require_relative '../lib/world_objects'
require_relative '../lib/world'
require_relative '../lib/config_file'
require_relative '../lib/snake'

module SnakeGame
  MAP_ = [['*', 'S', '*', 'W', '*'],
        ['*', '*', '*', 'W', '*'],
        ['*', '*', '*', '*', 'L'],
        ['P', 'H', '*', '*', '*'],
        ['*', '*', '*', '*', 'O']]
  SIZE_ = 5
  TIME_TO_APPEAR_NEW_LIFE_ = 10

  class SnakeTest < MiniTest::Unit::TestCase
    def setup
      world = World.new(SIZE_, MAP_, TIME_TO_APPEAR_NEW_LIFE_)
      @snake = Snake.new(world, 3, 0, Vector.new(3, 1), [Vector.new(3, 0)], Vector.new(0, 1))
    end

    def teardown
      @snake = nil
    end

    def test_energy
      assert_equal 0, @snake.energy
    end

    def test_energy
      assert_equal 3, @snake.lives
    end

    def test_lose_life
      @snake.lose_life
      assert_equal 2, @snake.lives
    end

    def test_gain_life
      @snake.gain_life
      assert_equal 4, @snake.lives
    end

    def test_dead?
      assert_equal false, @snake.dead?

      @snake.lives = 0
      assert_equal true, @snake.dead?
    end

    def test_move
      @snake.move(Movements::UP)
      assert_equal Vector.new(2, 1), @snake.head
      assert_equal nil, @snake.world[Vector.new(3, 0)]
    end

    def test_move_and_eat_super_food
      @snake.move(Movements::UP)
      @snake.move(Movements::UP)
      @snake.move(Movements::UP)

      assert_equal Vector.new(0, 1), @snake.head
      assert_instance_of SnakeHead, @snake.world[Vector.new(0, 1)]
      assert_instance_of SnakePart, @snake.world[Vector.new(1, 1)]
      assert_equal 3, @snake.energy
    end

    def test_move_to_opposite_direction
      @snake.move(Movements::UP)

      assert_raises(IllegalMove){ @snake.move(Movements::DOWN) }
    end
  end
end
