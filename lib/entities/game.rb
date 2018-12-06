# frozen_string_literal: true

class Game
  include Validator
  include Commands

  def initialize
    @process = Processor.new
    @data = DataStorage.new
  end

  def generate
    Array.new(4) { rand(1..6) }
  end

  def generate_game(hints:, attempts:, msg_name:)
    @code = generate
    @hints = hints
    @hints_used = 0
    @attempts = attempts
    @attempts_used = 0
    @game_end = false
    @hint_avaliable = true
    message(msg_name, {})
  end

  def new_game
    registration
    level_choice
    secret_code
  end

  def secret_code
    @menu = Menu.new
    loop do
      game_work
      break if @game_end
    end
    save_result
    message(:success_save_message, {})
    @menu.game_menu
  end

  def game_work
    message(:promt_to_enter_secret_code_hint_exit, {})
    choice = gets.chomp
    result = choice_process(choice)
    win(result)
    attempts_left
    lost_attempts
  end

  def save_result
    message(:save_results_message, {})
    choice = gets.chomp
    choice_save_process(choice)
  end

  def choice_save_process(choice)
    command_save(choice)
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
    array = list.push(object)
    @data.save(array)
  end

  def win(result)
    win_array = Array.new(4, '+')
    return unless result == win_array

    message(:win_game_message, {})
    @game_end = true
  end

  def registration
    message(:registration, {})
    @name = gets.chomp
    check_name(@name)
  end

  def level_choice
    message(:hard_level, {})
    @level = gets.chomp
    commands(@level)
  end

  def lost_attempts
    return unless @attempts == @attempts_used

    message(:lost_game_message, {})
    @game_end = true
    puts @code
  end

  def attempts_left
    @attempts_used += 1
  end

  def lost_hints
    return message(:have_no_hints_message, {}) unless @hint_avaliable == true

    number = @process.hint_process(@code)
    @hints_used += 1
    message(:digit_on_place, number: number, code: @code.index(number) + 1)
    @hint_avaliable = false if @hints_used == @hints
  end

  def choice_process(command)
    commands_in_game(command) unless command =~ /^[1-6]{4}$/
    @process.turn_process(@code, command)
  end
end
