# frozen_string_literal: true

class Processor
  def secret_code_proc(code, guess)
    code = code.to_i.digits.reverse
    guess = guess.to_i.digits.reverse
    result = ''

    code.zip(guess).each_with_index do |el, index|
      next unless el.first == el.last

      result += '+'
      guess[index], code[index] = nil
    end

    [guess, code].each(&:compact!)

    guess.each do |number|
      next unless code.include?(number)

      result += '-'
      code.delete_at(code.index(number))
    end

    result
  end

  def hint_process(hints)
    hints.pop
  end
end
