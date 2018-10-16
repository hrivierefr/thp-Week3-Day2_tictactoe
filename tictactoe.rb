require 'colorize'
require 'colorized_string'


#Classe incluant les méthodes relatives au plateau (1 instance par jeu)
class Board

	attr_accessor :grid, :empty_cases, :playable_grid

	def initialize
		@grid = Array.new(9,"_")
		@playable_grid = Array.new(9," ")
		@empty_cases = [0, 1, 2, 3, 4, 5, 6, 7, 8]
	end

	#Ajout des cases au plateau de jeu
	def add_case(boardcase, i)
		@grid[i] = boardcase
	end

	#Affichage du plateau
	def display_board
		@grid.each_with_index {|boardcase, i|
			print boardcase.print_case(i)
			if i % 3 == 2
				puts " "
			else
				print "|"
			end		
		}
	end

	#Affichage du plateau à jouer
	def display_empty_cases
		@empty_cases.each_with_index {|value, i|
			if value == i
				print " #{i} "
			else 
				print "   "
			end

			if i % 3 == 2
				puts " "
			else
				print "|"
			end		
		}
	end

	#Renvoie la valeur d'une case
	def case_value(i)
		@grid[i].value
	end

	def fill(i,sign)
		@grid[i].fill(sign)
		@empty_cases[i]=" "
	end

end

#Classe incluant les méthodes relatives aux cases (9 instances par jeu)
class BoardCase
	attr_accessor :value
	def initialize (value = "_")
		@value = value
	end

	#Modification de la valeur d'une case
	def fill(sign)
		@value = sign
	end

	#Coloration d'une case en fonction de sa valeur
	def print_case(i)
		if @value == "X"
			return " #{@value} ".white.on_blue.bold
		elsif @value == "O"
			return " #{@value} ".white.on_red.bold
		elsif @value == "_"
			return " #{@value} ".light_black.on_white.bold
		else
			return " #{i} "
		end
	end
				
end

#Classe incluant les méthodes relatives aux joueurs (2 instances par jeu)
class Player
	attr_accessor :name, :score, :sign
	def initialize
		@name = name
		@score = 0
	end
end

#Classe décrivant chaque évènement du jeu
class Game

	attr_accessor :player1, :player2, :grid, :case0, :case1, :case2, :case3, :case4, :case5, :case6, :case7, :case8, :round, :sign, :case_played, :new_players, :priority
	
	def initialize
		@new_players = true
	end

	#Initialisation du plateau de jeu
	def game_load
		@case0 = BoardCase.new
		@case1 = BoardCase.new
		@case2 = BoardCase.new
		@case3 = BoardCase.new
		@case4 = BoardCase.new
		@case5 = BoardCase.new
		@case6 = BoardCase.new
		@case7 = BoardCase.new
		@case8 = BoardCase.new
		@grid = Board.new
		@grid.add_case(@case0, 0)
		@grid.add_case(@case1, 1)
		@grid.add_case(@case2, 2)
		@grid.add_case(@case3, 3)
		@grid.add_case(@case4, 4)
		@grid.add_case(@case5, 5)
		@grid.add_case(@case6, 6)
		@grid.add_case(@case7, 7)
		@grid.add_case(@case8, 8)

		puts ""
		puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		print "!!!!!!!! " 
		print "  C'est parti pour le tic-tac-toe de l'enfer  ".bold.red.on_white 
		puts  " !!!!!!!!"
		puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

		@round = 1
	end

	#Saisie des noms des joueurs
	def players_names
		
		@player1 = Player.new
		@player2 = Player.new

		@player1.sign = "O"
		@player2.sign = "X"

		puts ""
		print "Quel est le nom du joueur n°1 (O) ? ".white.on_red
		print " > " 
		@player1.name = gets.chomp
		print "Quel est le nom du joueur n°2 (X) ? ".white.on_blue
		print " > "
		@player2.name = gets.chomp
	end

	#Premier joueur aléatoire
	def rdm_start
		puts ""
		sleep(0.5)
		puts "Tirage au sort du joueur qui va débuter la partie :"
		sleep(0.5)
		15.times do
			print "."
			sleep(0.15)
		end
		print "Suspense"
		15.times do
			print "."
			sleep(0.15)
		end

		@priority = rand(2)
		puts""
		sleep(1)
		print "C'est "
		if @priority == 1
			print " #{player2.name} ".white.on_blue.bold
		else
			print " #{player1.name} ".white.on_red.bold
		end
		puts " qui commence."
		sleep(1.5)
	end

	#Méthode pour évaluer s'il existe un vainqueur
	def no_winner
		i = 0
		while i < 3
		#Examen des colonnes
			if @grid.empty_cases.include?(i).! && (@grid.case_value(i) == @grid.case_value(i+3)) && (@grid.case_value(i) == @grid.case_value(i+6))
				return false
		#Examen des lignes	
			elsif @grid.empty_cases.include?(i*3).! && (@grid.case_value(i*3) == @grid.case_value(i*3+1)) && (@grid.case_value(i*3) == @grid.case_value(i*3+2))
				return false				
			end
			i += 1
		end
		
		#Examen des diagonales
		if @grid.empty_cases.include?(0).! && (@grid.case_value(0) == @grid.case_value(4)) && (@grid.case_value(0) == @grid.case_value(8))
			return false
		elsif @grid.empty_cases.include?(2).! && (@grid.case_value(2) == @grid.case_value(4)) && (@grid.case_value(2) == @grid.case_value(6))
			return false
		else
			return true
		end
	end

	#Exécution d'un tour de jeu
	def turn
		#Affichage du plateau
		puts ""
		@grid.display_board 
		puts ""

		#Détermination du joueur correspondant à ce tour de jeu
		if (@round + @priority).odd?
			print " #{player1.name} ".white.on_red.bold
			@sign = player1.sign
		else
			print " #{player2.name} ".white.on_blue.bold
			@sign = player2.sign
		end
		print ", à vous de jouer ! "

		#Saisie du choix de jeu
		play

		@grid.fill(@case_played, @sign)
		@round += 1
	end

	#Choix de la case de jeu
	def play
		puts "Choisissez le numéro que vous souhaitez jouer parmi :"
		@grid.display_empty_cases
		print "> "
		@case_played = gets.chomp

		if @case_played.between?("0","8") && @grid.empty_cases.include?(@case_played.to_i)
			@case_played = case_played.to_i
		else
			puts "Saisie invalide"
			play
		end
	end

	#Cas du match nul
	def draw
		puts ""
		@grid.display_board #Dernier affichage du plateau
		puts ""
		print "Match nul. Le score est toujours : "
		print_score
		print "Voulez-vous rejouer pour vous départager (o/n) ? > "
		if gets.chomp == "o"
			@new_players = false
			perform
		else
		end
	end

	#Annonce du vainqueur
	def winner_claim

		@grid.display_board #Dernier affichage du plateau
		puts ""
		if @sign == "O"
			print " Bravo #{@player1.name} ".white.on_red.bold
			@player1.score += 1
		elsif @sign == "X"
			print " Bravo #{@player2.name} ".white.on_blue.bold
			@player2.score += 1
		end
		puts ", vous avez gagné !"
		print "Le score est maintenant : "
		print_score
		puts ""
		new_game
	end

	def print_score
		print " #{@player1.name} #{player1.score} ".white.on_red.bold
		print " - "
		puts  " #{player2.score} #{@player2.name} ".white.on_blue.bold
	end

	#Proposition d'un nouveau jeu
	def new_game
		print "Souhaitez-vous rejouer (o/n)? > "
		if gets.chomp == "o"
			print "avec les mêmes joueurs (o/n) ? > "
			if gets.chomp == "o"
				@new_players = false
			else 
				@new_players = true
			end
			perform
		else
		end
	end


	#Méthode de gestion du jeu
	def perform

		#Initialisation du jeu
		if @new_players
			players_names
		end
		game_load

		rdm_start

		#Déroulement du jeu
		while no_winner && @round < 10
			turn
		end

		#Conclusion du jeu
		if no_winner.!
			winner_claim
		else 
			draw
		end				
	end

end

game = Game.new
game.perform