#!/usr/bin/env ruby
class Game
    attr_accessor :board
    def initialize
        self.board = Array.new(9) { 0 }.each_slice(3).to_a
    end

    def play(players)
        loop do
            players.each do |player|
                location = player.get_location(self)
                player.place_marker(self, location)
                show_board
                if player_wins?
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

    def show_board
        self.board.each { |row| puts "[#{row[0]}][#{row[1]}][#{row[2]}]".gsub("0", " ").gsub("-1", "X").gsub("1", "O") }
    end

    def place_marker(marker, location)
        self.board[location.first][location.last] = marker
    end

    def space_available?(row, col)
        self.board[row][col] == 0 ? true : puts("Space taken. Try again.")
    end

    def draw?
        self.board.join.count("0") == 0
    end

    def player_wins?
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

    def place_marker(game, location)
        game.place_marker(self.marker, location)
    end

    def get_location(game)
        begin
            puts "choose a row"
            row = gets.chomp.to_i
            puts "choose a column"
            col = gets.chomp.to_i
        end until within_range?(row, col) && game.space_available?(row, col)
        [row, col]
    end

    private
    def within_range?(row, col)
        row.between?(0, 2) && col.between?(0,2) ? true : puts("Out of range. Try again.")
    end
end

# returns an array that reflects the player turn order based on a dice roll
def get_play_order(player1, player2)
    players = [player1, player2]
    players.sort! { |one, two| one.roll_dice <=> two.roll_dice }.reverse!
end

player1 = Player.new("Player1", -1)
player2 = Player.new("Player2", 1)
game = Game.new

# determine who goes first
players = get_play_order(player1, player2)
puts("#{player1.name} rolled #{player1.last_roll} ... #{player2.name} rolled #{player2.last_roll}.")
puts("#{players[0].name} goes first!")
game.show_board

game.play(players)
