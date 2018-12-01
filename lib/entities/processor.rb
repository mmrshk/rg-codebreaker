class Processor
  def turn_process(code, guess)
    p code
    guess = guess.to_i.digits.reverse
    result_array = place_match(code, guess)
    result_array = out_of_place_match(result_array, code, guess)
    p result_array
    result_array
  end

  def place_match(code, guess)
    result = Array.new(4, ' ')
    code.zip(guess).each_with_index do |el, index|
      if el.first == el.last
        result[index] = '+'
      end
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

  def hint_process(code)
    number = code.sample
  end
end
