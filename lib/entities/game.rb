# frozen_string_literal: true

class Game
  WIN_ARRAY_LENGTH = 4

  def initialize
    @process = Processor.new
    @data = DataStorage.new
  end

  def generate
    Array.new(4) { rand(1..6) }
  end

  def generate_game(hints:, attempts:, msg_name:)
    @code = generate
    #@hints = @code.shuffle.first(hints)
    @hints = hints
    @hints_used = 0
    @attempts = attempts
    @attempts_used = 0
    @game_end = false
    @hint_avaliable = true
    message(msg_name)
  end

  def game_work(result)
    win(result)
    attempts_left
    check_for_lose
  end

  def save_game_result
    list = @data.load
    object = {
      name: @name ||= registration,
      difficulty: @level ||= level_choice,
      attempts_total: @attempts,
      attempts_used: @attempts_used ||= attempts_left,
      hints_total: @hints,
      hints_used: @hints_used ||= lost_hints
    }
    @data.save(list.push(object))
  end

  def check_for_lose
    return if @attempts != @attempts_used

    message(:lost_game_message)
    @game_end = true
    puts @code
  end

  def attempts_left
    @attempts_used += 1
  end

  def lost_hints
    return message(:have_no_hints_message) if !@hint_avaliable

    number = @process.hint_process(@code)
    @hints_used += 1
    message(:digit_on_place, number: number, code: @code.index(number) + 1)
    @hint_avaliable = false if @hints_used == @hints
  end
end
