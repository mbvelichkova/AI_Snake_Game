gem "minitest"
require 'minitest/autorun'
require '../lib/vector'

class VectorTest < MiniTest::Unit::TestCase
  def test_addition
    assert_equal Vector.new(3, 6), Vector.new(1, 3) + Vector.new(2, 3)
  end

  def test_multiplication
    assert_equal Vector.new(24, 9), Vector.new(8, 3) * 3
  end

  def test_subtraction
    assert_equal Vector.new(7, 3), Vector.new(9, 5) - Vector.new(2, 2)
  end

  def test_negation
     assert_equal Vector.new(-3, -5), -Vector.new(3, 5)
     assert_equal Vector.new(0, -5), -Vector.new(0, 5)
     assert_equal Vector.new(2, -4), -Vector.new(-2, 4)
  end

  def test_equation
    assert_equal true, Vector.new(0, 0) == Vector.new(0, 0)
    assert_equal true, Vector.new(1, 2) == Vector.new(1, 2)
    assert_equal true, Vector.new(-8, -6) == Vector.new(-8, -6)
    assert_equal false, Vector.new(8, 6) == Vector.new(-8, -6)
  end
  
  def test_not_equal
    assert_equal true, Vector.new(0, 0) != Vector.new(1, 5)
    assert_equal false, Vector.new(8, 6) != Vector.new(8, 6)
  end
  
  def test_opposite_direction
    assert_equal true, Vector.new(8, 6).opposite_direction(Vector.new(-8, -6))
  end
  
  def test_string_representation
    assert_equal "[8, 6]", Vector.new(8, 6).to_s
  end
end