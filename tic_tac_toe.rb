#!/usr/bin/env ruby
class Game
    attr_accessor :board, :players
    def initialize
        self.board = Array.new(9) { 0 }.each_slice(3).to_a
        self.players = set_turn_order(Player.new("Player 1", -1), Player.new("Player 2", 1))
    end

    def play
        show_last_roll_results
        loop do
            self.players.each do |player|
                location = player.get_location(self)
                place_marker(player.marker, location)
                show_board
                if player_wins?(location)
                    game_over = true
                    puts "GAME OVER #{player.name.upcase} WINS!"
                    return 
                elsif draw?
                    puts "GAME OVER - DRAW"
                    return
                end
            end
        end
    end

    def space_available?(row, col)
        self.board[row][col] == 0 ? true : puts("Space taken. Try again.")
    end

    private
    def show_last_roll_results
        puts("#{self.players[0].name} rolled #{self.players[0].last_roll} ... #{self.players[1].name} rolled #{self.players[1].last_roll}.")
        puts("#{self.players[0].name} goes first!")
    end

    def show_board
        self.board.each do |row| 
            puts "[#{row[0]}][#{row[1]}][#{row[2]}]".gsub("0", " ").gsub("-1", "X").gsub("1", "O")
        end
    end

    def place_marker(marker, location)
        self.board[location.first][location.last] = marker
    end

    def draw?
        self.board.join.count("0") == 0
    end

    def row_win?(row)
        sum = row.reduce { |total, val| total + val }
        sum == 3 || sum == -3
    end

    def diagonal_win?
        diag1 = self.board[0][0] + self.board[1][1] + self.board[2][2]
        diag2 = self.board[0][2] + self.board[1][1] + self.board[2][0]
        diag1 == 3 || diag1 == -3 || diag2 == 3 || diag2 == -3
    end

    def player_wins?(location)
        x = location.first
        y = location.last
        row = self.board[x]
        col = self.board.map { |row| row[y] }

        row_win?(row) || row_win?(col) || diagonal_win?
    end 

  private
       # returns an array that reflects the player turn order based on a dice roll
    def set_turn_order(player1, player2)
        players = [player1, player2]
        players.sort! { |one, two| one.roll_dice <=> two.roll_dice }.reverse!
    end

end

class Player
    attr_accessor :name, :last_roll, :marker

    def initialize(name, marker)
        self.name = name
        self.marker = marker
        self.last_roll = 0
    end

    def roll_dice
        self.last_roll = rand(1..100)
    end

    def get_location(game)
        begin
            puts "Choose a row"
            row = gets.chomp.to_i
            puts "Choose a column"
            col = gets.chomp.to_i
        end until within_range?(row, col) && game.space_available?(row, col)
        [row, col]
    end

    private
    def within_range?(row, col)
        row.between?(0, 2) && col.between?(0,2) ? true : puts("Out of range. Try again.")
    end
end

game = Game.new.play
