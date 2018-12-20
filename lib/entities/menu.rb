# frozen_string_literal: true

class Menu
  include Validator
  attr_reader :data, :renderer, :game

  COMMANDS = {
    start: 'start',
    exit_from_game: 'exit',
    rules: 'rules',
    stats: 'stats',
    hint: 'hint'
  }.freeze
  CHOOSE_COMMANDS = {
    yes: 'yes'
  }.freeze

  def initialize
    @data = DataStorage.new
    @renderer = Renderer.new
    @game = Game.new
    @statistics = Statistics.new
  end

  def game_menu
    renderer.start_message
    choice_menu_process(ask(:choice_options,
                            start: COMMANDS[:start],
                            rules: COMMANDS[:rules],
                            stats: COMMANDS[:stats],
                            exit: COMMANDS[:exit_from_game]))
  end

  private

  def rules
    renderer.rules
    game_menu
  end

  def start
    registration
    level_choice
    game_process
  end

  def stats
    render_stats(@statistics.stats(data.load)) if data.load
    game_menu
  end

  def ask(phrase_key = nil, hashee = {})
    renderer.message(phrase_key, hashee) if phrase_key
    gets.chomp
  end

  def save_result
    data.save_game_result(game.to_h(@name)) if ask(:save_results_message) == CHOOSE_COMMANDS[:yes]
  end

  def registration
    @name = ask(:registration)
    unless name_valid?
      renderer.registration_name_length_error
      registration
    end
  end

  def name_valid?
    !check_emptyness(@name) && check_length(@name)
  end

  def level_choice
    choose_level(ask(:hard_level, levels: Game::DIFFICULTIES.keys.join(' | ')))
  end

  def choose_level(level)
    return generate_game(level.to_sym) if Game::DIFFICULTIES[level.to_sym]
    return game_menu if level == COMMANDS[:exit_from_game]

    renderer.command_error
    level_choice
  end

  def generate_game(difficulty)
    game.generate(difficulty)
    renderer.message(difficulty)
  end

  def game_process
    while game.attempts.positive?
      return handle_win if player_wins

      renderer.round_message
      game.decrease_attempts!
    end
    handle_lose
  end

  def choice_code_process(command)
    case command
    when COMMANDS[:hint] then hint_process!
    when COMMANDS[:exit_from_game] then game_menu
    else handle_command(command)
    end
  end

  def handle_command(command)
    return p game.start_process(command) if check_command_range(command)

    renderer.command_error
    game_process
  end

  def player_wins
    guess = gets.chomp

    return true if game.win?(guess)

    game.win?(choice_code_process(guess))
  end

  def handle_win
    renderer.win_game_message
    save_result
    game_menu
  end

  def handle_lose
    renderer.lost_game_message(game.code)
    game_menu
  end

  def hint_process!
    return renderer.no_hints_message? if game.hints_spent?

    renderer.print_hint_number(game.take_a_hint!)
  end

  def exit_from_game
    renderer.goodbye_message
    exit
  end

  def choice_menu_process(command_name)
    case command_name
    when COMMANDS[:start] then start
    when COMMANDS[:exit_from_game] then exit_from_game
    when COMMANDS[:rules] then rules
    when COMMANDS[:stats] then stats
    else
      renderer.command_error
      game_menu
    end
  end

  def render_stats(list)
    list.each_with_index do |key, index|
      puts "#{index + 1}: "
      key.each { |el, value| puts "#{el}:#{value}" }
    end
  end
end
