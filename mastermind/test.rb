#!/usr/bin/env ruby
class Cell
  attr_accessor :value
  def initialize(value = "")
    @value = value
  end
end

def code_valid?(code)
  return false unless code.length == 4
  code.split('').each do |char|
    return false unless char.match(/\d/)
  end
  true
end

p code_valid?("1234")
p code_valid?("12i2")