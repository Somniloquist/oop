#!/usr/bin/env ruby
module Mastermind
  attr_accessor :value
  class Cell
    def initialize(value = "")
      @value = value
    end
  end
  
  class Board
    attr_reader :decoding_grid, :key_grid
    def initialize(input = {})
      @decoding_grid = input.fetch(:grid, default_decoding_grid)
      @key_grid = default_key_grid
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
    def default_decoding_grid
      Array.new(10) { Array.new(4) { Cell.new } }
    end

    def default_key_grid
      Array.new(10) { Array.new(4) { Cell.new } }
    end
  end

  class Player
    attr_reader :name
    def initialize(input)
      @name = input.fetch(:name)
    end
  end

  class Game
  end
end

include Mastermind
test = Board.new

test.decoding_grid[0][0].value = "1"
test.decoding_grid[0][1].value = "1"
test.decoding_grid[0][2].value = "1"
test.decoding_grid[0][3].value = "1"

test.key_grid[0][0].value = "X"
test.key_grid[0][3].value = "O"

test.print_formatted_board