#!/usr/bin/env ruby
class Board
    attr_accessor :board_area
    def initialize
        self.board_area = Array.new(9) { 0 }.each_slice(3).to_a
    end

    def show
        self.board_area.each { |row| puts "[#{row[0]}][#{row[1]}][#{row[2]}]".gsub("0", " ").gsub("-1", "X").gsub("1", "O") }
    end

    def place_marker(marker, location)
        board_area[location.first][location.last] = marker
    end
end

class Player
    attr_accessor :name, :win_count, :lose_count, :last_roll, :marker

    def initialize(name, marker)
        self.name = name
        self.marker = marker
        self.win_count = 0
        self.lose_count = 0
        self.last_roll = 0
    end

    def roll_dice
        self.last_roll = rand(1..100)
    end

    def place_marker(game_board, location)
        game_board.place_marker(self.marker, location)
    end

    def get_location
        row = -1
        col = -1
        while !valid_location?(row, col) do
            puts "choose a row"
            row = gets.chomp.to_i
            puts "choose a column"
            col = gets.chomp.to_i
        end
    [row, col]
    end

    private
    def valid_location?(row, col)
        row.between?(0, 2) && col.between?(0,2)
    end
end

# returns an array that reflects the player turn order based on a dice roll
def get_play_order(player1, player2)
    players = [player1, player2]
    players.sort! { |one, two| one.roll_dice <=> two.roll_dice }.reverse!
end

def game
    # initialize the two players
    player1 = Player.new("Player1", -1)
    player2 = Player.new("Player2", 1)

    # determine who goes first
    players = get_play_order(player1, player2)
    puts("#{player1.name} rolled #{player1.last_roll} ... #{player2.name} rolled #{player2.last_roll}.")
    puts("#{players[0].name} goes first!")

    board = Board.new
    board.show

    # first player is assigned 'x' second player is assigned 'o'
    # player picks a coordinate on the board
    players.each do |player|
        location = player.get_location
        player.place_marker(board, location)
        board.show
    end
    # place symbol at coordinate
    # check win condition


end

game