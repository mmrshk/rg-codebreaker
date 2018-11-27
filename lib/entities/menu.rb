class Menu
  include Commands
  def initialize
    @game = Game.new
    @data = DataStorage.new
  end

  def game_menu
    @data.create unless @data.storage_exist?
    puts I18n.t(:start_message)
    puts I18n.t(:choice_options)
    choice = gets.chomp
    choice_process(choice)
  end

  def start_game
    @game.new_game
  end

  def rules
    puts I18n.t(:rules)
    game_menu
  end

  def stats
    list = @data.load
    hell = []
    medium = []
    easy = []

    list.select{  |key, hash|
      if key[:difficulty] == "hell"
        hell.push(key)
      elsif key[:difficulty] == "medium"
        medium.push(key)
      elsif key[:difficulty] = "easy"
        easy.push(key)
      end
    }

    stats_sort(hell)
    stats_sort(medium)
    stats_sort(easy)

    list = hell + medium + easy

    list.each_with_index  {|key, index|
      puts "#{index}: #{key}"
    }
    
    game_menu
  end

  def stats_sort(array)
    array.sort! { |x,y|
      y[:hints_used] <=> x[:hints_used]
      y[:attempts_used] <=> x[:attempts_used]
    }
  end

  def choice_process(command_name)
    if main_commands.dig(command_name.to_sym).nil?
      puts I18n.t(:command_error)
      game_menu
    else
      main_commands.dig(command_name.to_sym).call
    end
  end

  def exit_from_game
    puts I18n.t(:goodbye_message)
    exit
  end
end
