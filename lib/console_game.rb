require_relative './game'

module SnakeGame
	class ConsoleGame 
		def initialize(win_score = 10, level = 1)
			@game = Game.new(nil, win_score, level)
			@win_score = win_score
			@game.init_ai
			@player_snake = nil
		end
		
		def choose_player_snake(snake)
			@player_snake = snake
		end
		
		def draw_playground_map
			update_game_states
			puts @game.world
		end
		
		def update_game_states
			@game.snakes.each do |player, snake|
				if player == @player_snake
					puts 'PLAYER SNAKE: ' + player.to_s
				else 
					puts 'ENEMY SNAKE: ' + player.to_s
				end
				puts '	Score:' + snake.energy.to_s
				puts '	Lives:' + snake.lives.to_s
				if snake.dead?
					puts (@player_snake == player ? 'Player ' : 'Enemy ') + player.to_s + ' is dead.' 
				elsif snake.energy == @win_score
					puts (@player_snake == player ? 'Player ' : 'Enemy ') + player.to_s + ' wins!'
				end  
			end
    end
						
		def won?
			@game.snakes.each do |player, snake|
				if snake.energy == @win_score
					puts (@player_snake == player ? 'Player ' : 'Enemy ') + player.to_s + ' wins!'
					return true
				end
			end
			false
		end
		
		def game_over?
			@game.snakes.each do |player, snake|
				if player == @player_snake and snake.dead?
					puts 'Game over!'
					puts (@player_snake == player ? 'Player ' : 'Enemy ') + player.to_s + ' is dead.' 
					return true
				end
			end
			false
		end
		
		def player_move(command)
			snake = @game.snakes[@player_snake]
			new_head_position = snake.head
			case command
			when 'up'
				new_head_position = Movements::UP + snake.head
			when 'down'
				new_head_position = Movements::DOWN + snake.head
			when 'left'
				new_head_position = Movements::LEFT + snake.head
			when 'right'
				new_head_position = Movements::RIGHT + snake.head
			when 'in'
				if @game.world[snake.head].over_tunnel
					tunnel = @game.world.tunnels[snake.head]
					new_head_position = tunnel.exit if tunnel
				end
			end

			@game.move(snake, new_head_position)
		end
		
		def enemies_move()
			@game.snakes.each do |player, snake|
				if player != @player_snake
					@game.move_with_ai(snake)
				end
			end
		end
		
		
		def play_auto()
			@game.init_ai
			loop do
				@game.snakes.each do |player, snake|
					break if snake.energy == @win_score
					@game.move_with_ai(snake)
				end
			end
		end
	end
end