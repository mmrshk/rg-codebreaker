# frozen_string_literal: true

module Commands
  def commands_in_game(command_name)
    @menu = Menu.new
    case command_name
    when 'hint' then lost_hints
    when 'exit' then @menu.game_menu
    else check_command(command_name)
    end
  end

  def commands(level)
    @menu = Menu.new
    case level
    when 'easy' then generate_game(hints: 2, attempts: 15, msg_name: :easy_game)
    when 'medium' then generate_game(hints: 1, attempts: 10, msg_name: :medium_game)
    when 'hell' then generate_game(hints: 1, attempts: 5, msg_name: :hell_game)
    when 'exit' then @menu.game_menu
    else check_level
    end
  end

  def command_save(command_name)
    @menu = Menu.new
    case command_name
    when 'yes' then save_game_result
    when 'no' then @menu.game_menu
    else check_save
    end
  end

  def main_commands(command_name)
    case command_name
    when 'start' then start_game
    when 'exit' then exit_from_game
    when 'rules' then rules
    when 'stats' then stats
    else
      message(:command_error)
      game_menu
    end
  end

  def message(msg_name, hashee = {})
    puts I18n.t(msg_name, **hashee)
  end
end
