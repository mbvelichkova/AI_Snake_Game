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
    
    def initialize(coords, energy, set_food_count)
      @energy = energy
      @set_food_count = set_food_count
      super(coords)
    end
  end
  
  class OrdinaryFood < Food
    def initialize(coords)
      super(coords, 1,  1)
      @image = 'O'
    end
    
    def set_food(coords)
      OrdinaryFood.new(coords)
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
		attr_accessor :over_tunnel
    def initialize(coords)
      super
      @image = 'H'
			@over_tunnel = false
    end
		
		def set_over_tunnel(bool)
			@over_tunnel = bool
			@image = bool ? '[H]' : 'H'
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