require_relative './console_game'

class GameLoop
		include SnakeGame
		DIRECTIONS_STRINGS = ['up', 'down', 'left', 'right', 'in']
		
    def self.main_loop
      print "Type \'exit\' to quit the game or \'restart\' to restart it! You can leave it empty and use default settings.\n"
			STDIN.flush
			print "Choose game map! Enter 1 or 2.\n"
			STDOUT.flush
      map_number = gets.chomp == "" ? 1 : gets.to_i
			print "You choose game map " + map_number.to_s + "\n"
			
			print "Choose winning score! Enter a number. You can leave it empty and use default settings.\n"
			STDOUT.flush
      score = gets.chomp == "" ? 15 : gets.chomp.to_i
			print "You choose winning score to be " + score.to_s
			
      game = ConsoleGame.new(score, map_number)
			
			print "Choose your snake as entering a number. Or leave it empty and watch the game."
			STDOUT.flush
      auto_play = gets.chomp == "" ? true : false
			player = gets.chomp.to_i
			game.choose_player_snake(player) unless auto_play
			print "You choose to play auto \n" if auto_play
			print "You choose to play with " + player.to_s + "\n" unless auto_play
			
      loop do
        game.draw_playground_map
				if auto_play
					game.enemies_move
					
					print "If you want to quick enter \'exit\'.\n"
					STDOUT.flush
					command = gets.chomp
					return if command == 'exit'
					next 
				else
					print "Choose direction! Enter left, right, up or down.If you are on tunnel, enter \'in\' to go to the other side.\n"
					STDOUT.flush
					command = gets.chomp
					return if command == 'exit'
					if command == 'restart'
						game = ConsoleGame.new(score, map_number)
					else
						if DIRECTIONS_STRINGS.include? command
							game.player_move(command)
							game.enemies_move
						else
							print "Invalid command! Try again!\n"
							next
						end
					end
					if game.won?
						print "Congratulations! You win!\n"
						return
					elsif game.game_over?
						print "Game over!\n"
					end
				end
      end
    end
  end

GameLoop.main_loop