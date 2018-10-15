#Classe incluant les méthodes relatives au plateau (1 instance par jeu)
class Board

	attr_accessor :grid

	def initialize
		@grid = Array.new(9)
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
			else 
				print "#{boardcase.value} "
			end				
		}
	end

	#Liste des cases pouvant être jouées au prochain tour
	def list_empty_cases
		empty_cases = []
		@grid.each_index {|i|
			if @grid[i].value == " "
				empty_cases << i
			end
		}
		return empty_cases
	end

end

#Classe incluant les méthodes relatives aux cases (9 instances par jeu)
class BoardCase
	attr_accessor :value
	def initalize(value=" ")
		@value = value
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

	attr_accessor :player1, :player2, :grid, :case0, :case1, :case2, :case3, :case4, :case5, :case6, :case7, :case8, :turn, :sign, :new_players
	
	def initialize
		@player1 = Player.new
		@player2 = Player.new
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
		@turn = 1
		@new_players = true
	end

	#Méthode d'initialisation du plateau de jeu
	def board_composition
		@grid.add_case(@case0, 0)
		@grid.add_case(@case1, 1)
		@grid.add_case(@case2, 2)
		@grid.add_case(@case3, 3)
		@grid.add_case(@case4, 4)
		@grid.add_case(@case5, 5)
		@grid.add_case(@case6, 6)
		@grid.add_case(@case7, 7)
		@grid.add_case(@case8, 8)
	end

	#Méthode de saisie des noms des joueurs
	def players_names
		print "Quel est le nom du joueur n°1 (O) ? > "
		@player1.name = gets.chomp
		print "Quel est le nom du joueur n°2 (X) ? > "
		@player2.name = gets.chomp
	end

	#Méthode pour évaluer s'il existe un vainqueur
	def winner

		i = 0
		while i < 3
		#Examen des colonnes
			if (@grid[i].value != " ") && (@grid[i].value == @grid[i+3].value) && (@grid[i].value == @grid[i+6].value)
				return true
		#Examen des lignes	
			elsif (@grid[i*3].value != " ") && (@grid[i*3].value == @grid[i*3+1].value) && (@grid[i*3].value == @grid[i*3+2].value)
				return true				
			end
			i += 1
		end
		
		#Examen des diagonales
		if (@grid[0].value != " ") && (@grid[0].value == @grid[4].value) && (@grid[0].value == @grid[8].value)
			return true
		elsif (@grid[2].value != " ") && (@grid[2].value == @grid[4].value) && (@grid[2].value == @grid[6].value)
			return true
		else
			return false
		end
	end


	#Méthode décrivant un tour de jeu
	def turn

		@grid.display_board #Affichage du plateau

		#Détermination du joueur correspondant à ce tour de jeu
		if turn.odd?
			print player1.name 
			@sign = "0"
		else
			print player2.name
			@sign = "X"
		end
		puts ", où souhaitez vous jouer ?"

		#Saisie du choix de jeu
		print "Saisissez l'indice de la case parmi : #{@grid.empty_cases} > "
		case_played = gets.chomp
		@grid[case_played].value = @sign

		@turn += 1
	end



	def perform
		if new_players
			players_names
		end

		board_composition

		while winner.!
			turn
		end

		#Annonce du vainqueur
		if @sign == "0"
			print "Bravo #{@player1.name}"
		elsif @sign == "X"
			print "Bravo #{@player2.name}"
		end
		puts ", vous avez gagné !"

		#Proposition d'un nouveau jeu
		print "Souhaitez-vous rejouer (o/n)? > "
		if gets.chomp == "o"
			print "avec les mêmes joueurs (o/n) ? > "
			if gets.chomp == "o"
				new_players = false
			end
			perform
		end
	end
end

game = Game.new
game.perform