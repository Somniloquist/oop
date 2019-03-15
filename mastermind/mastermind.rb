#!/usr/bin/env ruby
module Mastermind
  class Cell
    attr_accessor :value
    def initialize(value = "")
      @value = value
    end
  end
  
  class Board
    attr_accessor :decoding_grid, :key_grid
    attr_reader :pegs, :secret
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
    attr_accessor :current_turn
    attr_reader :board, :player, :ai_player, :max_turns, :code_length
    def initialize(input = {})
      @player = get_human_player
      @ai_player = get_ai_player
      @board = Board.new(secret: get_secret_code)
      @current_turn = 1
      @max_turns = input.fetch(:turns, 10)
      @code_length = input.fetch(:code_length, 4)
    end

    def play
      code_breaker = 1
      message = "Break the code!"

      if player.role == code_breaker
        max_turns.times do 
          puts("===== Turn #{current_turn} =====")
          guess = solicit_code { puts(message) }
          push_to_decoding_grid(guess)
          if codes_match?(guess, board.secret)
            puts("You win!")
            return
          else
            matches = get_code_matches(guess, board.secret)
            push_to_key_grid(matches)
            board.print_formatted_board
          end

          current_turn < 10 ? next_turn : puts("You lose.")
        end
      else
        puts "Code Master Not yet implemented."
        puts "Ending game."
      end
    end

    private
    def push_to_decoding_grid(code)
      code = code.map { |value| Cell.new(value) }
      board.decoding_grid.push << code
    end

    def push_to_key_grid(code)
      board.key_grid.push << code
    end

    def next_turn
      @current_turn += 1
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

    def codes_match?(guess, secret)
      secret_code = secret.map { |cell| cell.value }
      guess == secret_code
    end

    def get_code_matches(guess, secret)
      matches = []
      # compare exact matches
      code_length.times do |i|

        # for testign
        p("guess:#{guess[i]}, secret:#{secret[i].value}")

        matches << Cell.new("1") if secret[i].value == guess[i]
      end

      matches
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

    def solicit_code
      yield if block_given?
      loop do
        print("Enter a four digit code: ")
        # convert to_i to strip non number characters before converting to_a
        # bug: this method strips leading zeros
        code = gets.chomp.to_i.to_s.split('')
        return code if code.length == code_length
      end
    end

    def get_secret_code
      return get_random_code if self.player.role == 1
      solicit_code { puts "You are the Code Master. Choose a secret code."}
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
game.play