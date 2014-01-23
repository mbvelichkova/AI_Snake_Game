require_relative 'vector'
require 'win32console'

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
  end
end

class String
  { :reset => 0,
    :bold => 1,
    :dark => 2,
    :underline => 4,
    :blink => 5,
    :negative => 7,
    :black => 30,
    :red => 31,
    :green => 32,
    :yellow => 33,
    :blue => 34,
    :magenta => 35,
    :cyan => 36,
    :white => 37,
    :white_back => 47,
  }.each do |key, value|
    define_method key do
      "\e[#{value}m" + self + "\e[0m"
    end
  end
end