#!/usr/bin/env ruby
class Cell
  attr_accessor :value
  def initialize(value = "")
    @value = value
  end
end

def test
  secret = [1,1,1,1]
  guess  = [1,1,4,0]
  rough_matches = []
  matches = []

  guess.each_with_index do |cell, cell_i|
    4.times do |i|
      if cell == secret[i]
        p("#{guess[cell_i]} : #{secret[i]}")
        rough_matches << 0
        secret[i] = nil
        break
      end
    end
  end

  p secret
  p guess

  p rough_matches

end

test