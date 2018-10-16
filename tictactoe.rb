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
			if i % 3 == 2
				puts boardcase.value
				print
			else 
				print "#{boardcase.value} | "
			end				
		}
	end

	def case_value(i)
		@grid[i].value
	end

	def fill(i,sign)
		@grid[i].fill(sign)
		@empty_cases.delete(i)
	end

	#Tableau des cases pouvant être jouées au prochain tour
	def playable_grid
		@grid.each_index {|i|
			if i % 3 == 2
				if @empty_cases.include?(i)
					puts i
				else 
					puts " "
				end
			else 
				if @empty_cases.include?(i)
					print "#{i} | "
				else 
					print "  | "
				end
			end
		}
	end
end

#Classe incluant les méthodes relatives aux cases (9 instances par jeu)
class BoardCase
	attr_accessor :value
	def initialize (value = "_")
		@value = value
	end

	def fill(sign)
		@value = sign
	end
end

#Classe incluant les méthodes relatives aux joueurs (2 instances par jeu)
class Player
	attr_accessor :name
	def initialize
		@name = name
	end
end

#Classe décrivant chaque évènement du jeu
class Game

	attr_accessor :player1, :player2, :grid, :case0, :case1, :case2, :case3, :case4, :case5, :case6, :case7, :case8, :round, :sign, :case_played, :new_players
	
	def initialize
		@player1 = Player.new
		@player2 = Player.new
		@grid = Board.new
		@new_players = true
	end

	#Méthode d'initialisation du plateau de jeu
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
		@round = 1

		puts ""
		puts "C'est parti pour le tic-tac-toe de l'enfer !!"
		puts ""
	end

	#Méthode de saisie des noms des joueurs
	def players_names
		puts ""
		print "Quel est le nom du joueur n°1 (O) ? > "
		@player1.name = gets.chomp
		print "Quel est le nom du joueur n°2 (X) ? > "
		@player2.name = gets.chomp
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


	#Méthode décrivant un tour de jeu
	def turn

		@grid.display_board #Affichage du plateau

		#Détermination du joueur correspondant à ce tour de jeu
		if @round.odd?
			print player1.name 
			@sign = "O"
		else
			print player2.name
			@sign = "X"
		end
		puts ", à vous de jouer ! "

		#Saisie du choix de jeu
		play

		@grid.fill(@case_played, @sign)
		@round += 1
	end

	#Choix de la case de jeu
	def play
		puts "Choisissez le numéro que vous souhaitez jouer parmi :"
		@grid.playable_grid
		print "> "
		@case_played = gets.chomp.to_i
		if @grid.empty_cases.include?(@case_played).!
			puts "Saisie invalide"
			play
		end
	end

	#Cas du match nul
	def draw
		puts ""
		print "Match nul. Voulez-vous rejouer pour vous départager (o/n) ? > "
		if gets.chomp == "o"
			@new_players = false
			perform
		else
		end
	end

	#Annonce du vainqueur
	def winner_claim

		@grid.display_board #Dernier affichage du plateau

		if @sign == "O"
			print "Bravo #{@player1.name}"
		elsif @sign == "X"
			print "Bravo #{@player2.name}"
		end
		puts ", vous avez gagné !"

		new_game
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