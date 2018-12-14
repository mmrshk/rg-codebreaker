# frozen_string_literal: true

class Processor
  PLUS = '+'
  MINUS = '-'
  def secret_code_proc(code, guess)
    code = code.to_i.digits.reverse
    guess = guess.to_i.digits.reverse
    result = ''

    code.zip(guess).each_with_index do |el, index|
      next unless el.first == el.last

      result += PLUS
      guess[index], code[index] = nil
    end

    [guess, code].each(&:compact!)

    guess.each do |number|
      next unless code.include?(number)

      result += MINUS
      code.delete_at(code.index(number))
    end

    result
  end

  def hint_process(hints)
    hints.pop
  end
end
