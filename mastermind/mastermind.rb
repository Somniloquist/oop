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
    attr_reader :decoding_grid, :key_grid, :pegs, :secret
    def initialize(input = {})
      @secret = input.fetch(:secret)
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
    end

    def print_formatted_secret
      self.secret.each { |cell| print "#{cell.value} " }
      puts ""
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
    def initialize()
      @player = get_human_player
      @ai_player = get_ai_player
      @board = Board.new(secret: get_secret_code)
    end

    def play
    end

    private
    def get_human_player
      player_name = solicit_name
      # assume player will always choose code breaker for now
      player_role = 2 #solicit_role
      Player.new(name: player_name, role: player_role)
    end

    def get_ai_player
      self.player.role == 1 ? ai_role = 2 : ai_role = 1
      Player.new(name: "Computer", role: ai_role)
    end

    def solicit_role
      loop do
        print("Select a role. [1]Code Breaker | [2]Code Master: ")
        role = gets.chomp.to_i
        return role if role.between?(1,2)
      end
    end

    def solicit_name
      print("What is your name?: ")
      gets.chomp
    end

    def solicit_secret_code
      puts("You are the code master, choose a secret code.")
      loop do
        print("Enter a 4 digit code: ")
        # convert to_i to strop non number characters before converting to_a
        code = gets.chomp.to_i.to_s.split('')
        return code if code.length == 4
      end
    end

    def get_secret_code
      return get_random_code if self.player.role == 1
      solicit_secret_code
    end

    def get_random_code
      code = []
      4.times { code << Cell.new((0..9).to_a.sample.to_s) }
      code
    end

  end

end

include Mastermind
game = Game.new

# puts "====== TURN 1 ======="
# board.decoding_grid << [Cell.new("1"), Cell.new("2"), Cell.new("3"), Cell.new("4")]
# board.key_grid << [Cell.new, Cell.new, Cell.new, Cell.new]
# board.print_formatted_board
# puts "====== TURN 2 ======="
# board.decoding_grid << [Cell.new("1"), Cell.new("2"), Cell.new("3"), Cell.new("4")]
# board.key_grid << [Cell.new, Cell.new, Cell.new, Cell.new]
# board.print_formatted_board