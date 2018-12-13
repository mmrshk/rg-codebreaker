# frozen_string_literal: true

class Menu
  include Validator
  attr_reader :data, :renderer, :game

  START = :start
  EXIT = :exit
  RULES = :rules
  STATS = :stats
  HINT = :hint
  YES = :yes
  NO = :no
  WIN = '++++'

  def initialize
    @data = DataStorage.new
    @renderer = Renderer.new
    @process = Processor.new
    @game = Game.new
    @statistics = Statistics.new
  end

  def game_menu
    @data.create unless @data.storage_exist?
    @renderer.start_message
    @renderer.choice_options
    choice_menu_process(gets.chomp)
  end

  private

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
    @statistics.stats(@data)
    game_menu
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
    choose_level(@level)
  end

  def secret_code
    until check_for_lose == false || win(choice_code_process(gets.chomp)) == true
      @renderer.promt_to_enter_secret_code_hint_exit
      @game.decrease_attempts
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
    game_operations(command)

    p @game.start_process(command)
  end

  def exit_from_game
    @renderer.goodbye_message
    exit
  end

  def win(result)
    return if result != WIN

    @renderer.win_game_message
    true
  end

  def save_game_result
    list = @data.load

    object = {
      name: @name,
      difficulty: @level,
      all_attempts: Game::DIFFICULTIES[Game::EASY][:attempts],
      attempts_used: @game.calculate(:tries, @level),
      all_hints: Game::DIFFICULTIES[Game::EASY][:hints],
      hints_used: @game.calculate(:suggestions, @level)
    }

    @data.save(list.push(object))
  end

  def choice_menu_process(command_name)
    case command_name.to_sym
    when START then new_game
    when EXIT then exit_from_game
    when RULES then rules
    when STATS then stats
    else
      @renderer.command_error
      game_menu
    end
  end

  def game_operations(command_name)
    case command_name.to_sym
    when HINT then lost_hints
    when EXIT then game_menu
    else check_command(command_name)
    end
  end

  def choose_level(level)
    case level.to_sym
    when Game::EASY then call_generate_game(Game::EASY)
    when Game::MEDIUM then call_generate_game(Game::MEDIUM)
    when Game::HELL then call_generate_game(Game::HELL)
    when EXIT then game_menu
    else check_level
    end
  end

  def call_generate_game(difficulty)
    @game.generate_game(Game::DIFFICULTIES[difficulty])
    @renderer.message(difficulty)
  end

  def choice_save_process(command_name)
    case command_name.to_sym
    when YES then save_game_result
    when NO then game_menu
    else check_save
    end
  end
end
