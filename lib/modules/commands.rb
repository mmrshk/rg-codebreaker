module Commands
  def commands_in_game
    @menu = Menu.new
    {
      hint: -> { lost_hints },
      exit: -> { @menu.game_menu }
    }
  end

  def commands
    {
      easy: -> { generate_easy_game },
      medium: -> { generate_medium_game },
      hell: -> { generate_hell_game }
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
end
