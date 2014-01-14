require_relative './world_objects'
require_relative './vector'

module SnakeGame
  class World
    attr_reader :world, :life, :food

    def initialize(width, map, time_to_new_life)
      @world_size = width
      @time_to_new_life = time_to_new_life
      @local_time_to_new_life = @time_to_new_life
      initialize_world(map)
    end

    def [](position)
      row, column = position.x, position.y
      @world[row][column]
    end

    def []=(position, value)
      row, column = position.x, position.y
      @world[row][column] = value
    end

    def size
      @world_size
    end

    def update
      update_food_lives
      update_life_lives if @life

      if @life == nil
        @local_time_to_new_life = @local_time_to_new_life - 1
        set_life if @local_time_to_new_life == 0
      elsif @life.lives == 0
        @world[@life.coords.x][@life.coords.y] = nil
        @life = nil
        @local_time_to_new_life = @time_to_new_life
      end
    end

    def in_bounds?(position)
      if position.x >= 0 and position.x < @world_size and
          position.y >= 0 and position.y < @world_size
        true
      else
        false
      end
    end

    def update_food(food)
      number_of_new_food = food.set_food_count
      1.upto(number_of_new_food) do
        begin
          x = Random.rand(@world_size)
          y = Random.rand(@world_size)
        end while @world[x][y]

        coords = Vector.new(x,y)
        new_food = food.set_food(coords)
        @world[x][y] = new_food
        @food << new_food
      end
      food_index = @food.index(food)
      @food.delete_at(food_index)
    end

    def eat_life
      @life = nil
      @local_time_to_new_life = @time_to_new_life
    end

    def to_s
      output = ''
      @world.each.with_index do |row, i|
        row.each.with_index do |object, j|
          image = object ? object.image : '*'
          space = (j < row.size - 1) ? ' ' : ''
          output << image + space
        end
        output << "\n" if i < (@world.size - 1)
      end
      "#{output}"
    end

    #private
    def update_food_lives
      @food.each.with_index do |food, i|
        food.lives = food.lives - 1
        if food.lives == 0
          @world[food.coords.x][food.coords.y] = nil
          update_food(food)
        end
      end
    end

    def update_life_lives
      @life.lives = @life.lives - 1
    end

    def set_life
      begin
        x = Random.rand(@world_size)
        y = Random.rand(@world_size)
      end while @world[x][y]
      coords = Vector.new(x,y)
      @life = Life.new(coords)
    end

    def initialize_world(map)
      @world = Array.new(@world_size) { Array.new(@world_size) }
      @food = []
      @life = nil
      map.each.with_index do |row, i|
        row.each.with_index do |object, j|
          if object == '*'
            @world[i][j] = nil
          elsif object == 'O'
            ordinary_food = OrdinaryFood.new(Vector.new(i, j))
            @world[i][j] = ordinary_food
            @food << ordinary_food
          elsif object == 'S'
            super_food = SuperFood.new(Vector.new(i, j))
            @world[i][j] = super_food
            @food << super_food
          elsif object == 'W'
            @world[i][j] = Wall.new(Vector.new(i, j))
          elsif object == 'P'
            snake_part = SnakePart.new(Vector.new(i, j))
            @world[i][j] = snake_part
          elsif object == 'H'
            snake_head = SnakeHead.new(Vector.new(i, j))
            @world[i][j] = snake_head
          elsif object == 'L'
            @life = Life.new(Vector.new(i, j))
            @world[i][j] = life
          end
        end
      end
    end
  end
end