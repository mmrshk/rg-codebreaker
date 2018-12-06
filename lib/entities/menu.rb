# frozen_string_literal: true

class Menu
  include Commands
  def initialize
    @game = Game.new
    @data = DataStorage.new
  end

  def game_menu
    @data.create unless @data.storage_exist?
    message(:start_message, {})
    message(:choice_options, {})
    choice = gets.chomp
    choice_process(choice)
  end

  def start_game
    @game.new_game
  end

  def rules
    message(:rules, {})
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

  def choice_process(command_name)
    main_commands(command_name)
  end

  def exit_from_game
    message(:goodbye_message, {})
    exit
  end
end
