# frozen_string_literal: true

class Menu
  include Validator
  attr_reader :data, :renderer, :game

  COMMANDS = {
    start: 'start',
    exit: 'exit',
    rules: 'rules',
    stats: 'stats',
    hint: 'hint'
  }.freeze
  CHOOSE_COMMANDS = {
    yes: 'yes',
    no: 'no'
  }.freeze

  def initialize
    @data = DataStorage.new
    @renderer = Renderer.new
    @game = Game.new
    @statistics = Statistics.new
  end

  def game_menu
    @renderer.start_message
    choice_menu_process(ask(:choice_options,
                            start: COMMANDS[:start],
                            rules: COMMANDS[:rules],
                            stats: COMMANDS[:stats],
                            exit: COMMANDS[:exit]))
  end

  private

  def rules
    @renderer.rules
    game_menu
  end

  def new_game
    registration
    level_choice
    game_process
  end

  def stats
    render_stats(@statistics.stats(@data))
    game_menu
  end

  def ask(phrase_key = nil, hashee = {})
    @renderer.message(phrase_key, hashee)
    gets.chomp
  end

  def save_result
    choice_save_process(ask(:save_results_message))
  end

  def registration
    @name = ask(:registration)
    unless name_valid?
      @renderer.registration_name_length_error
      registration
    end
  end

  def name_valid?
    !check_emptyness(@name) && check_length(@name)
  end

  def level_choice
    @level = ask(:hard_level, levels: Game::DIFFICULTIES.keys.join(' | '))
    choose_level(@level)
  end

  def game_process
    until player_lose || player_wins
      @renderer.promt_to_enter_secret_code_hint_exit
      @game.decrease_attempts!
    end

    game_menu
  end

  def player_wins
    return if !@game.win?(choice_code_process(gets.chomp))

    @renderer.win_game_message
    save_result
    @renderer.success_save_message
    true
  end

  def player_lose
    return if @game.attempts.positive?

    @renderer.lost_game_message(@game.code)
    true
  end

  def take_a_hint!
    return @renderer.no_hints_message? if @game.hints_spent?

    @renderer.digit_on_place(@game.hint_process)
  end

  def choice_code_process(command)
    case command
    when COMMANDS[:hint] then take_a_hint!
    when COMMANDS[:exit] then game_menu
    else handle_command(command)
    end
  end

  def handle_command(command)
    return p @game.start_process(command) if check_command_range(command)
    @renderer.command_error
    game_process
  end

  def exit_from_game
    @renderer.goodbye_message
    exit
  end

  def choice_menu_process(command_name)
    case command_name
    when COMMANDS[:start] then new_game
    when COMMANDS[:exit] then exit_from_game
    when COMMANDS[:rules] then rules
    when COMMANDS[:stats] then stats
    else
      @renderer.command_error
      game_menu
    end
  end

  def choose_level(level)
    return call_generate_game(level.to_sym) if !Game::DIFFICULTIES[level.to_sym].nil?
    return game_menu if level == COMMANDS[:exit]

    @renderer.command_error
    level_choice
  end

  def call_generate_game(difficulty)
    @game.generate_game(Game::DIFFICULTIES[difficulty])
    @renderer.message(difficulty)
  end

  def choice_save_process(command_name)
    case command_name
    when CHOOSE_COMMANDS[:yes] then @data.save_game_result(@game.to_h(@name, @level))
    when CHOOSE_COMMANDS[:no] then game_menu
    else
      @renderer.command_error
      save_result
    end
  end

  def render_stats(list)
    list.each_with_index do |key, index|
      puts "#{index + 1}: "
      key.each { |el, value| puts "#{el}:#{value}" }
    end
  end
end
