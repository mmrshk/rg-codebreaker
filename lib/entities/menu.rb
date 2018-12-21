# frozen_string_literal: true

class Menu
  include Validator
  attr_reader :storage, :renderer, :game, :guess

  COMMANDS = {
    start: 'start',
    exit: 'exit',
    rules: 'rules',
    stats: 'stats',
  }.freeze
  CHOOSE_COMMANDS = {
    yes: 'yes'
  }.freeze
  MIN_SIZE_VALUE = 3
  MAX_SIZE_VALUE = 20

  def initialize
    @storage = DataStorage.new
    @renderer = Renderer.new
    @game = Game.new
    @statistics = Statistics.new
  end

  def game_menu
    renderer.start_message
    choice_menu_process(ask(:choice_options, commands: COMMANDS.keys.join(' | ')))
  end

  private

  def rules
    renderer.rules
    game_menu
  end

  def start
    @name = registration
    level_choice
    game_process
  end

  def stats
    users_data = storage.load
    render_stats(@statistics.stats(users_data)) if users_data
    game_menu
  end

  def ask(phrase_key = nil, options = {})
    renderer.message(phrase_key, options) if phrase_key
    gets.chomp
  end

  def save_result
    storage.save_game_result(game.to_h(@name)) if ask(:save_results_message) == CHOOSE_COMMANDS[:yes]
  end

  def registration
    loop do
      name = ask(:registration)

      return name if name_valid?(name)

      renderer.registration_name_length_error
    end
  end

  def name_valid?(name)
    !check_emptyness(name) && check_length(name, MIN_SIZE_VALUE, MAX_SIZE_VALUE)
  end

  def level_choice
    loop do
      level = ask(:hard_level, levels: Game::DIFFICULTIES.keys.join(' | '))

      return generate_game(level.to_sym) if Game::DIFFICULTIES[level.to_sym]
      return game_menu if level == COMMANDS[:exit]

      renderer.command_error
    end
  end

  def generate_game(difficulty)
    game.generate(difficulty)
    renderer.message(:difficulty,
                     hints: Game::DIFFICULTIES[difficulty.to_sym][:hints],
                     attempts: Game::DIFFICULTIES[difficulty.to_sym][:attempts])
  end

  def game_process
    while game.attempts.positive?
      @guess = ask
      return handle_win if game.win?(guess)

      game_round
    end
    handle_lose
  end

  def game_round
    choice_code_process
    renderer.round_message
    game.decrease_attempts!
  end

  def choice_code_process
    case guess
    when Game::HINT then hint_process!
    when COMMANDS[:exit] then game_menu
    else handle_command(guess)
    end
  end

  def handle_command(command)
    return p game.start_process(command) if check_command_range(command)

    renderer.command_error
    game_process
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
    when COMMANDS[:exit] then exit_from_game
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
      key.each { |param, value| puts "#{param}:#{value}" }
    end
  end
end
