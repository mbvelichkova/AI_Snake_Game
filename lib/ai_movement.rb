require "set"
require_relative 'vector'
require_relative 'world_objects'

module SnakeGame
	NeighbourCells = [Vector.new(0, -1),
								Vector.new(-1, 0),
								Vector.new(1, 0),
								Vector.new(0, 1),]
								
	class ComputeDistances
			def self.bfs(map, root)
			distance_map = Array.new(map.size) { Array.new(map.size) }
			visited = {}
			queue = Array.new
			
			queue.push(root)
			visited[root] = true
			distance_map[root.x][root.y] = 0
			until queue.empty? 
				cell = queue.shift
				neighbours = []
				
				#find out the neighbours
				NeighbourCells.each do |neighbour|
					neighbour += cell
					neighbours.push(neighbour)
				end
				#add one more neighbour when we have a tunnel 
				if map[cell].is_a? Tunnel
					neighbours.push(map[cell].exit)
				end
				
				neighbours.each do |neighbour|				
					if map.in_bounds?(neighbour) and not visited[neighbour] 
						unless map[neighbour].is_a? Wall
							queue.push(neighbour)
							visited[neighbour] = true
							distance_map[neighbour.x][neighbour.y] = distance_map[cell.x][cell.y] + 1 #because they are always neighbour cells
						end
					end
				end
			end
			distance_map
		end
	end
	
	class AStar
		INF = 1e20
		attr_accessor :distance_from_start, :map_distances
		def initialize(map, target)
			@target = target
			@distance_from_start = Array.new(map.size) { Array.new(map.size, INF) }
			@map = map
			@map_distances = ComputeDistances.bfs(map, target)
		end
		
	def a_star(start_cell)
		start = OrderVectorByDistance.new(start_cell, self)
		priority_set = SortedSet.new([start])
		@distance_from_start[start.x][start.y] = 0
		
		unless priority_set.empty?
			front = priority_set.each.first
			priority_set.delete(front)
				
			return nil if front == @target
				
			neighbours = []
			#find out the neighbours
			NeighbourCells.each do |neighbour|
				neighbour += front
				neighbours.push(OrderVectorByDistance.new(neighbour, self))
			end
			#add one more neighbour when we have a tunnel 
			if @map[front].is_a? Tunnel
				neighbours.push(OrderVectorByDistance.new(@map[front].exit, self))
			end
				
			neighbours.each do |neighbour|
				if @map.in_bounds?(neighbour) and 
						not(@map[neighbour].is_a? Wall or @map[neighbour].is_a? SnakePart)
					#because we are moving always with one move
					new_distance = @distance_from_start[front.x][front.y] + 1 
					if @distance_from_start[neighbour.x][neighbour.y] > new_distance
            #update distance
						priority_set.delete(neighbour)
						@distance_from_start[neighbour.x][neighbour.y] = new_distance
						priority_set.add(neighbour)
					end
				end
			end
			priority_set.each.first
		end
	end
		
		class OrderVectorByDistance < Vector
			def initialize(vector, a_star)
				super(vector.x, vector.y)
				@a_star = a_star
			end
			
			def distance(cell)
				dist = @a_star.distance_from_start[cell.x][cell.y]  + @a_star.map_distances[cell.x][cell.y]
				dist
			end
			
			def <=>(other)
				current_dist = distance(self)
				other_dist = distance(other)
				result = current_dist <=> other_dist 
				if result == 0 
					self.hash <=> other.hash
				else
					result
				end
			end
		end
	end
	

	#test class
	class Map
		attr_accessor :map, :size
		
		def initialize(size)
			@size = size 
			@map = Array.new(size) { Array.new(size) }
			@map.each.with_index do |row, i|
        row.each.with_index do |object, j|
					@map[i][j] = nil
				end
			end
		end
		
		 def [](position)
      row, column = position.x, position.y
      @map[row][column]
    end

    def []=(position, value)
      row, column = position.x, position.y
      @map[row][column] = value
    end
		
		def in_bounds?(position)
      if position.x >= 0 and position.x < @size and
          position.y >= 0 and position.y < @size
        true
      else
        false
      end
    end
	end
end