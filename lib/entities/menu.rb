# frozen_string_literal: true

class Menu
  include Validator
  include Commands

  def initialize
    @game = Game.new
    @data = DataStorage.new
  end

  def game_menu
    @data.create unless @data.storage_exist?
    message(:start_message)
    message(:choice_options)
    choice = gets.chomp
    choice_menu_process(choice)
  end

  def rules
    message(:rules)
    game_menu
  end

  def stats_sort(array)
    array.sort! do |x, y|
      y[:hints_used] <=> x[:hints_used]
      y[:attempts_used] <=> x[:attempts_used]
    end
  end

  def select_difficulty(list, difficulty)
    array = []
    list.select { |key, _| array.push(key) if key[:difficulty] == difficulty }
    array
  end

  def difficulty(list, difficulty)
    array = select_difficulty(list, difficulty)
    stats_sort(array)
  end

  def stats
    list = @data.load
    hell = difficulty(list, 'hell')
    medium = difficulty(list, 'medium')
    easy = difficulty(list, 'easy')
    list = hell + medium + easy
    list.each_with_index { |key, index| puts "#{index}: #{key}" }
    game_menu
  end

  def exit_from_game
    message(:goodbye_message)
    exit
  end

  def new_game
   registration
   level_choice
   @game.secret_code
  end

  def save_result
    message(:save_results_message, {})
    choice = gets.chomp
    choice_save_process(choice)
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

  def secret_code
    while @game_end do
      message(:promt_to_enter_secret_code_hint_exit)
      choice = gets.chomp
      game_work(choice_code_process(choice))
    end
    save_result
    message(:success_save_message)
    game_menu
  end

  def choice_code_process(command)
    commands_in_game(command) unless command =~ /^[1-6]{4}$/
    @process.turn_process(@code, command)
  end

  def choice_save_process(choice)
    command_save(choice)
  end

  def choice_menu_process(command_name)
    main_commands(command_name)
  end
end
