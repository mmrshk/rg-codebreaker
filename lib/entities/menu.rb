# frozen_string_literal: true

class Menu
  include Validator
  include Commands
  attr_reader :data, :renderer

  def initialize
    @data = DataStorage.new
    @renderer = Renderer.new
    @game = Game.new
  end

  def game_menu
    @data.create unless @data.storage_exist?
    @renderer.start_message
    @renderer.choice_options
    choice_menu_process(gets.chomp)
  end

  def rules
    @renderer.rules
    game_menu
  end

  def new_game
    registration
    level_choice
    secret_code
  end

  def stats
    Statistics.new.stats(self)
  end

  def save_result
    @renderer.save_results_message
    choice_save_process(gets.chomp)
  end

  def registration
    @renderer.registration
    @name = gets.chomp
    check_name(@name)
  end

  def level_choice
    @renderer.hard_level
    @level = gets.chomp
    commands_to_choose_level(@level, @game)
  end

  def secret_code
    until @game.check_for_lose == false || win(choice_code_process(gets.chomp)) == true
      @renderer.promt_to_enter_secret_code_hint_exit
      @game.attempts_left
    end

    save_result
    @renderer.success_save_message
    game_menu
  end

  def choice_code_process(command)
    commands_in_game(command, @game)
    @game.start_process(command)
  end

  def choice_save_process(choice)
    command_save(choice)
  end

  def choice_menu_process(command_name)
    main_commands(command_name)
  end

  def exit_from_game
    @renderer.goodbye_message
    exit
  end

  def win(result)
    return if result != Array.new(Game::WIN_ARRAY_LENGTH, '+')

    @renderer.win_game_message
    true
  end

  def save_game_result
    list = @data.load
    object = {
      name: @name,
      difficulty: @level,
      attempts_used: @game.calculate(:tries, @level),
      hints_used: @game.calculate(:suggestions, @level)
    }

    @data.save(list.push(object))
  end
end
