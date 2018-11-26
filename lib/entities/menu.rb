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
    list.each_with_index  {|val, index|
      #puts "#{index}: #{val}"
      if val[:difficulty] == "hell"
        puts "Hell"
        puts "#{index}: #{val}"
      elsif val[:difficulty] == "medium"
        puts "Medium"
        puts "#{index}: #{val}"
      elsif val[:difficulty] = "easy"
        puts "Easy"
        puts "#{index}: #{val}"
      end
      #binding.pry
    }
    game_menu
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
