# frozen_string_literal: true

module Commands
  START = 'start'
  EXIT = 'exit'
  RULES = 'rules'
  STATS = 'stats'
  HINT = 'hint'
  YES = 'yes'
  NO = 'no'

  def main_commands(command_name)
    case command_name
    when START then new_game
    when EXIT then exit_from_game
    when RULES then rules
    when STATS then stats
    else
      renderer.command_error
      game_menu
    end
  end

  def commands_in_game(command_name, game)
    case command_name
    when HINT then game.lost_hints
    when EXIT then game_menu
    else check_command(command_name)
    end
  end

  def commands_to_choose_level(level, game)
    case level
    when Game::EASY then game.generate_game(Game::DIFFICULTIES[Game::EASY.to_sym])
    when Game::MEDIUM then game.generate_game(Game::DIFFICULTIES[Game::MEDIUM.to_sym])
    when Game::HELL then game.generate_game(Game::DIFFICULTIES[Game::HELL.to_sym])
    when EXIT then game_menu
    else check_level
    end
  end

  def command_save(command_name)
    case command_name
    when YES then save_game_result
    when NO then game_menu
    else check_save
    end
  end
end
