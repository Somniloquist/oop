#!/usr/bin/env ruby

def test
  loop do
    print("Enter a 4 digit code: ")
    code = gets.chomp.to_i.to_s.split('')
    return code if code.length == 4
  end

end

test