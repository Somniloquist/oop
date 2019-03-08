#!/usr/bin/env ruby
class Board
    attr_accessor :board_area
    def initialize
        self.board_area = Array.new(9) { " " }
    end

    def show
        self.board_area.each_slice(3).to_a.each { |row| puts " #{row[0]} | #{row[1]} | #{row[2]} " }
    end
end

class Player
    attr_accessor :name, :win_count, :lose_count, :last_roll

    def initialize(name)
        self.name = name
        self.win_count = 0
        self.lose_count = 0
        self.last_roll = 0
    end

    def roll_dice
        self.last_roll = rand(1..100)
    end
end

# returns an array that reflects the player turn order based on a dice roll
def get_play_order(player1, player2)
    players = [player1, player2]
    players.sort! { |one, two| one.roll_dice <=> two.roll_dice }.reverse!
end

def game
    # initialize the two players
    player1 = Player.new("Player1")
    player2 = Player.new("Player2")

    # determine who goes first
    players = get_play_order(player1, player2)
    puts("#{player1.name} rolled #{player1.last_roll} ... #{player2.name} rolled #{player2.last_roll}.")
    puts("#{players[0].name} goes first!")

    board = Board.new
    board.show

end

game