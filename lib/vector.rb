class Vector
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end

  def +(other)
    Vector.new(x + other.x, y + other.y)
  end
  
  def -(other)
    Vector.new(x - other.x, y - other.y)
  end
  
  def *(scalar)
    Vector.new(x * scalar, y * scalar)
  end
  
  def ==(other)
    x == other.x and y == other.y
  end
  
  def -@
    Vector.new(-x, -y)
  end
  
  def opposite_direction(other)
    other + self == Vector.new(0,0)
  end
  
  def to_s
    "[#{@x}, #{@y}]"
  end
end