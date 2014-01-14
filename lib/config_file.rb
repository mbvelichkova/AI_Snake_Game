require_relative 'vector'
module SnakeGame
  module Movements
    LEFT = Vector.new(0, -1)
    RIGHT = Vector.new(0, 1)
    UP = Vector.new(-1, 0)
    DOWN = Vector.new(1, 0)
  end

  module Configuration
    FILE = { 1 => 'level_1.txt',
            2 => 'level_2.txt' }
    SCORE_LEVEL = { 1 => 20,
                    2 => 50 }
    TIME_TO_NEW_LIFE = { 1 => 10,
                        2 => 15 }
  end
end