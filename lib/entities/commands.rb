# frozen_string_literal: true

class Commands
  include Validator

  START = 'start'
  EXIT = 'exit'
  RULES = 'rules'
  STATS = 'stats'
  HINT = 'hint'
  YES = 'yes'
  NO = 'no'

  def main_operations(command_name, menu)
    case command_name
    when START then menu.new_game
    when EXIT then menu.exit_from_game
    when RULES then menu.rules
    when STATS then menu.stats
    else
      menu.renderer.command_error
      menu.game_menu
    end
  end

  def game_operations(command_name, menu)
    case command_name
    when HINT then menu.lost_hints
    when EXIT then menu.game_menu
    else check_command(command_name)
    end
  end

  def choose_level(level, menu)
    case level
    when Game::EASY then menu.game.generate_game(Game::DIFFICULTIES[Game::EASY.to_sym])
    when Game::MEDIUM then menu.game.generate_game(Game::DIFFICULTIES[Game::MEDIUM.to_sym])
    when Game::HELL then menu.game.generate_game(Game::DIFFICULTIES[Game::HELL.to_sym])
    when EXIT then menu.game_menu
    else check_level
    end
  end

  def save_operation(command_name, menu)
    case command_name
    when YES then menu.save_game_result
    when NO then menu.game_menu
    else check_save
    end
  end
end
