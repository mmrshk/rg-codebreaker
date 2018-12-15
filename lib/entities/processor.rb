# frozen_string_literal: true

class Processor
  MATCHED_DIGIT_CHAR = '+'
  UNMATCHED_DIGIT_CHAR = '-'

  attr_reader :guess, :code, :result

  def secret_code_proc(code, guess)
    @code = code.each_char.map(&:to_i)
    @guess = guess.each_char.map(&:to_i)
    @result = ''
    handle_matched_digits
    handle_matched_digits_with_wrong_position

    result
  end

  def handle_matched_digits
    code.each_with_index do |el, index|
      next unless code[index] == guess[index]

      @result += MATCHED_DIGIT_CHAR
      @guess[index], @code[index] = nil
    end
  end

  def handle_matched_digits_with_wrong_position
    guess.compact.each do |number|
      next unless @code.include?(number)

      @result += UNMATCHED_DIGIT_CHAR
      @code.delete_at(code.index(number))
    end
  end
end
