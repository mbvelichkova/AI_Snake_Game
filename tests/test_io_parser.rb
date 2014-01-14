gem "minitest"
require 'minitest/autorun'
require '../lib/io_parser'
require '../lib/vector'

module SnakeGame
  WORLD =
  "* * * * * * * * * * * * * * * * * * * *
  * * * * * * * * * * * * * * * * * * * *
  * * * * * * * * * * * * * * * * * * * *
  * * * * * * * * * W W W W * * * * * * *
  * * * * * * * * * * * * * * * * * * * *
  * * * * * O * * * * * * * * * * * * * *
  * * * * * * * * * * * * * * * * * * * *
  * * * * * * * * * * * * * * * * * * * *
  P P H * * * * * * * * * * * * * * * * *
  * * * * * * * * * * * * * * * * * * * *
  * * * * * * * * * * * * * * * * * * * *
  * * * * * * * * * * * * * * * * * * * *
  * * * * * * * W * * * * * S * * * * * *
  * * * * * * * W * * * * * * * * * * * *
  * * * * * * * W * * * * * * * * * * * *
  * * * * * * * * * * * * * * * * * * * *
  * * * * * * * * * * * * * * * * * * * *
  * * * * * * * * * * * W W W W * * * * *
  * * * * * * * * * * * * * * * * * * * *
  W W W * * * * * * * * * * * * * * * * *"

  class IOTest < MiniTest::Unit::TestCase
    SCORE = 0
    DIRECTION = Vector.new(0, 1)
    SNAKE_HEAD = Vector.new(8, 2)
    SNAKE_BODY = [Vector.new(8, 2), Vector.new(8, 1), Vector.new(8, 0)]

    def setup
      @io = IO.new
      @io.read_file("level_1.txt")
    end

    def test_read_file_score
      assert_equal SCORE, @io.score
    end

    def test_read_file_snake
      assert_equal DIRECTION, @io.direction
      assert_equal SNAKE_HEAD, @io.snake_head
      assert_equal SNAKE_BODY, @io.snake_body
    end

    def test_read_file_world
      world = WORLD.split("\n").map{ |s| s.split }
      assert_equal world, @io.file_map
    end

    def test_read_from_not_existing_file
      assert_raises(IOError){ @io.read_file("not_existing.txt") }
    end
  end
end