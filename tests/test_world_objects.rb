gem "minitest"
require 'minitest/autorun'
require '../lib/world_objects'
require '../lib/vector'

module SnakeGame
  class FoodTest < MiniTest::Unit::TestCase
    def test_create_ordinary_food
      food = OrdinaryFood.new(Vector.new(1, 2))
      assert_equal Vector.new(1, 2), food.coords
      assert_equal 1, food.energy
      assert_equal 15, food.lives
      assert_equal 1, food.set_food_count
      assert_equal 'O', food.image
    end

    def test_create_super_food
      food = SuperFood.new(Vector.new(5, 2))
      assert_equal Vector.new(5, 2), food.coords
      assert_equal 3, food.energy
      assert_equal 10, food.lives
      assert_equal 3, food.set_food_count
      assert_equal 'S', food.image
    end

    def test_set_food_from_ordinary_food
      food = OrdinaryFood.new(Vector.new(5, 2))
      new_food = food.set_food(Vector.new(4, 5))
      assert_equal true, (new_food.instance_of?(OrdinaryFood) or new_food.instance_of?(SuperFood))
    end

    def test_set_food_from_super_food
      food = SuperFood.new(Vector.new(5, 2))
      new_food = food.set_food(Vector.new(4, 5))
      assert_equal true, new_food.instance_of?(OrdinaryFood)
      assert_equal false, new_food.instance_of?(SuperFood)
    end
  end

  class WallTest < MiniTest::Unit::TestCase
    def test_create_wall
      wall = Wall.new(Vector.new(9,4))
      assert_equal Vector.new(9,4), wall.coords
      assert_equal 'W', wall.image
    end
  end

  class LifeTest < MiniTest::Unit::TestCase
    def test_create_life
      life = Life.new(Vector.new(6, 3))
      assert_equal Vector.new(6, 3), life.coords
      assert_equal 17, life.lives
      assert_equal 'L', life.image
    end
  end

  class SnakePartTest < MiniTest::Unit::TestCase
    def test_create_snake_part
      snake_part = SnakePart.new(Vector.new(3,4))
      assert_equal Vector.new(3,4), snake_part.coords
      assert_equal 'P', snake_part.image
    end
  end

  class SnakeHeadTest < MiniTest::Unit::TestCase
    def test_create_snake_head
      snake_head = SnakeHead.new(Vector.new(3,3))
      assert_equal Vector.new(3,3), snake_head.coords
      assert_equal 'H', snake_head.image
      refute_equal 'P', snake_head.image
    end
  end
end