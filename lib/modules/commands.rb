module Commands
  def commands_in_game
    @menu = Menu.new
    {
      hint: -> { lost_hints },
      exit: -> { @menu.game_menu }
    }
  end

  def commands
    @menu = Menu.new
    {
      easy: -> { generate_game(hints: 2, attempts: 15, msg_name: :easy_game) },
      medium: -> { generate_game(hints: 1, attempts: 10, msg_name: :medium_game) },
      hell: -> { generate_game(hints: 1, attempts: 5, msg_name: :hell_game) },
      exit: -> { @menu.game_menu }
    }
  end

  def command_save
    @menu = Menu.new
   {
     yes: -> { save_game_result },
     no: -> { @menu.game_menu }
   }
  end

  def main_commands
    {
      start: -> { start_game },
      rules: -> { rules },
      stats: -> { stats },
      exit: -> { exit_from_game }
    }
  end

  def message(msg_name)
    I18n.t(msg_name)
  end
end
