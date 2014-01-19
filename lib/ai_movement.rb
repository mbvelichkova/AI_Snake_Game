require_relative 'vector'
require_relative 'world_objects'
module SnakeGame
	class ComputeCellPrices
		NeighbourCells = [Vector.new(0, -1),
									Vector.new(-1, 0),
									Vector.new(1, 0),
									Vector.new(0, 1),]
	
		def bfs(map, root)
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
							puts neighbour
							queue.push(neighbour)
							visited[neighbour] = true
							distance_map[neighbour.x][neighbour.y] = distance_map[cell.x][cell.y] + 1
						end
					end
				end
			end
			distance_map
		end
	end
	
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