#!/usr/bin/env ruby
module Mastermind
  attr_accessor :value
  class Cell
    def initialize(value = "")
      @value = value
    end
  end
  
  class Board
    attr_accessor :decoding_grid, :key_grid
    attr_reader :decoding_grid, :key_grid, :pegs
    def initialize(input = {})
      @decoding_grid = []
      @key_grid = []
      @pegs = default_pegs
    end

    def print_formatted_board
      grid_border = "| "
      self.decoding_grid.reverse.each_with_index do |row, i|
        row.each { |cell| print("#{cell.value.empty? ? ' ' : cell.value} ")}
        print grid_border
        self.key_grid.reverse[i].each { |cell| print "#{cell.value.empty? ? '' : cell.value + ' '}" }
        puts ""
      end

      nil
    end

    private
    def default_pegs
      "123456".split("")
    end
  end

  class Player
    attr_reader :name, :role
    def initialize(input)
      @name = input.fetch(:name)
      @role = input.fetch(:role)
    end

  end

  class Game
    attr_reader :board, :player, :ai_player
    def initialize(board = Board.new)
      @player = get_human_player
      @ai_player = get_ai_player
    end

    def play
    end

    def get_human_player
      player_name = solicit_name
      player_role = solicit_role
      Player.new(name: player_name, role: player_role)
    end

    def get_ai_player
      self.player.role == 1 ? ai_role = 2 : ai_role = 1
      Player.new(name: "Computer", role: ai_role)
    end

    def solicit_role
      loop do
        print ("Select a role. [1 - Code Breaker | 2 - Code Master]: ")
        role = gets.chomp.to_i
        return role if role.between?(1,2)
      end
    end

    def solicit_name
      print("What is your name?: ")
      gets.chomp
    end

  end

end

include Mastermind
game = Game.new
board = Board.new
p game.player.name
p game.player.role

p game.ai_player.name
p game.ai_player.role

# puts "====== TURN 1 ======="
# board.decoding_grid << [Cell.new("1"), Cell.new("2"), Cell.new("3"), Cell.new("4")]
# board.key_grid << [Cell.new, Cell.new, Cell.new, Cell.new]
# board.print_formatted_board
# puts "====== TURN 2 ======="
# board.decoding_grid << [Cell.new("1"), Cell.new("2"), Cell.new("3"), Cell.new("4")]
# board.key_grid << [Cell.new, Cell.new, Cell.new, Cell.new]
# board.print_formatted_board