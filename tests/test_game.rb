gem "minitest"
require 'minitest/autorun'
require '../lib/game.rb'

module SnakeGame
  class GameTest < MiniTest::Unit::TestCase
    def test_initialize_default
      game = Game.new
      assert_equal 0, game.score
      assert_equal 1, game.level
    end
    
    def test_initialize_custom
      game = Game.new("d.txt",  10,  2)
      assert_equal 10, game.score
      assert_equal 2, game.level
    end
  end
end