# frozen_string_literal: true

class Processor
  def secret_code_process(code, guess)
    guess = guess.to_i.digits.reverse
    result_array = place_match(code, guess)
    out_of_place_match(result_array, code, guess)
  end

  def place_match(code, guess)
    result = Array.new(Game::DIGITS_COUNT, ' ')
    code.zip(guess).each_with_index do |el, index|
      result[index] = '+' if el.first == el.last
    end
    result
  end

  def out_of_place_match(result, code, guess)
    matched_values = code & guess
    guess.each_with_index do |number, index|
      if matched_values.include?(number)
        result[index] = '-' unless result[index] == '+'
      end
    end
    result
  end

  def hint_process(hints)
    hints.pop
  end
end
