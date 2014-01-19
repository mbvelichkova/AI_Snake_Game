# lib/snake_game/world_object.rb
module SnakeGame
  class WorldObject
    attr_reader :coords, :image
    
    def initialize(coords)
      @coords = coords
    end
  end
  
  class Food < WorldObject
    attr_reader :energy, :set_food_count
    attr_accessor :remain_time
    
    def initialize(coords, energy, remain_time, set_food_count)
      @energy = energy
      @remain_time = remain_time
      @set_food_count = set_food_count
      super(coords)
    end
  end
  
  class SuperFood < Food
    def initialize(coords)
      super(coords, 3, 10, 3)
      @image = 'S'
    end
    
    def set_food(coords)
      OrdinaryFood.new(coords)
    end
  end
  
  class OrdinaryFood < Food
    def initialize(coords)
      super(coords, 1, 15, 1)
      @image = 'O'
    end
    
    def set_food(coords)
      random = Random.rand(10)
      if random % 3 == 0
        SuperFood.new(coords)
      else
        OrdinaryFood.new(coords)
      end
    end
  end
  
  class Life < WorldObject
    attr_accessor :remain_time
    
    def initialize(coords)
      super(coords)
      @remain_time = 17
      @image = 'L'
    end
  end
  
  class Wall < WorldObject
    def initialize(coords)
      super
      @image = 'W'
    end
  end
  
  class SnakePart < WorldObject
    def initialize(coords)
      super
      @image = 'P'
    end
  end
  
  class SnakeHead < SnakePart
    def initialize(coords)
      super
      @image = 'H'
    end
  end
	
	class Tunnel < WorldObject
		attr_reader :start, :exit
		def initialize(start, exit)
			super(start)
			@start, @exit = start, exit
			@image = 'T'
		end
	end
end