#!/usr/bin/env ruby
class Cell
  attr_accessor :value
  def initialize(value = "")
    @value = value
  end
end

def code_valid?(code)
  return false unless code.length == 4
  code.each do |char|
    return false unless char.match(/\d/)
  end
  true
end

def solicit_code
  loop do
    print("Enter a four digit code: ")
    code = gets.chomp.split('')
    return code.map {|value|Cell.new(value)} if code_valid?(code)
  end
end

def get_random_code
  code = []
  4.times { code << Cell.new((0..9).to_a.sample.to_s) }
  code
end

code = solicit_code
p code
code = get_random_code
p code