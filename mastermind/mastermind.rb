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
    attr_reader :secret
    def initialize(input = {})
      @secret = input.fetch(:secret)
      @decoding_grid = []
      @key_grid = []
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
      puts "--------+"
    end
  end

  class Player
    attr_reader :role
    def initialize(input)
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
      code_breaker, code_master = 1, 2

      case player.role
      when code_breaker
        max_turns.times do 
          puts("===== Turn #{current_turn} =====")
          guess = solicit_code
          push_to_decoding_grid(guess)
          matches = get_code_matches(guess, board.secret)
          push_to_key_grid(matches)

          if codes_match?(guess, board.secret)
            show_game_over_message("===== CONGRATULATIONS - YOU WIN =====")
            return
          end

          board.print_formatted_board
          next_turn
        end

        show_game_over_message("===== GAME OVER - YOU LOSE =====")
      when code_master
        puts "Code Master Not yet implemented."
        puts "Ending game."
      end
    end

    private

    def show_game_over_message(message)
      puts(message)
      board.print_formatted_secret
      board.print_formatted_board
    end

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
      player_role = solicit_role
      Player.new(role: player_role)
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
      # copy into new array to avoid mutating the originals
      guess_copy = guess[0, guess.length]
      secret_copy = secret.map { |cell| cell.value }

      matches = extract_exact_matches(guess_copy, secret_copy)
      rough_matches = extract_rough_matches(guess_copy, secret_copy)
      rough_matches.length.times do |thing|
        matches << Cell.new("0")
      end

      matches
    end

    def extract_rough_matches(arr1, arr2)
      matches = []
      arr1.each_with_index do |a1_value, a1_index|
        code_length.times do |a2_index|
          if a1_value == arr2[a2_index]
            matches << a1_value
            arr2[a2_index] = nil
            break
          end
        end
      end
      matches.compact
    end

    def extract_exact_matches(arr1, arr2)
      matches = []
      code_length.times do |i|
        if arr1[i] == arr2[i]
          matches << Cell.new("1") 
          # set elements to nil to prevent running out of bounds
          arr1[i], arr2[i] = nil
        end
      end
      matches.compact
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
      loop do
        print("Enter a four digit code: ")
        code = gets.chomp.split('')
        return code if code_valid?(code)
      end
    end

    def code_valid?(code)
      return false unless code.length == 4
      code.each do |char|
        return false unless char.match(/\d/)
      end
      true
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