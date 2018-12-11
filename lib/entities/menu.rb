# frozen_string_literal: true

class Menu
  include Validator
  attr_reader :data, :renderer, :game

  def initialize
    @data = DataStorage.new
    @renderer = Renderer.new
    @game = Game.new
    @command = Commands.new
  end

  def game_menu
    @data.create unless @data.storage_exist?
    @renderer.start_message
    @renderer.choice_options
    choice_menu_process(gets.chomp)
    #@renderer.message(msg_name)
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

  def check_for_lose
    return unless @game.attempts.zero?

    @renderer.lost_game_message(@game.code)
    false
  end

  def stats
    Statistics.new.stats(self) #redo
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
    @command.choose_level(@level, @menu)
  end

  def secret_code
    until check_for_lose == false || win(choice_code_process(gets.chomp)) == true
      @renderer.promt_to_enter_secret_code_hint_exit
      @game.attempts_left
    end

    save_result
    @renderer.success_save_message
    game_menu
  end

  def lost_hints
    return @renderer.no_hints_message? if @game.hints.empty?

    @renderer.digit_on_place(@process.hint_process(@game.hints))
  end

  def choice_code_process(command)
    @command.game_operations(command, @menu)
    @game.start_process(command)
  end

  def choice_save_process(choice)
    @command.save_operation(choice, @menu)
  end

  def choice_menu_process(command_name)
    @command.main_operations(command_name, @menu)
  end

  def exit_from_game
    @renderer.goodbye_message
    exit
  end

  def win(result)
    return if result != Array.new(Game::DIGITS_COUNT, '+')

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
