class Game
  include Validator
  include Commands
  @@name = ''
  @@level = ''
  @@attempts_used = 0
  @@hints_used = 0

  def initialize
    @process = Processor.new
    @data = DataStorage.new
  end

  def generate
    Array.new(4) { rand(1..6) }
  end

  def generate_easy_game
    @code = generate
    @hints = 2
    @attempts = 15
    @game_end = false
    @hint_avaliable = true
    puts I18n.t(:easy_game)
  end

  def generate_medium_game
    @code = generate
    @hints = 1
    @attempts = 10
    @game_end = false
    @hint_avaliable = true
    puts I18n.t(:medium_game)
  end

  def generate_hell_game
    @code = generate
    @hints = 1
    @attempts = 5
    @game_end = false
    @hint_avaliable = true
    puts I18n.t(:hell_game)
  end

  def new_game
    registration
    level_choice
    secret_code
  end

  def secret_code
    @menu = Menu.new
    loop do
      puts I18n.t(:promt_to_enter_secret_code_hint_exit)
      choice = gets.chomp
      result = choice_process(choice)
      win(result)
      attempts_left
      lost_attempts
      break if @game_end
    end
    save_result
    puts I18n.t(:success_save_message)
    @menu.game_menu
  end

  def save_result
    puts I18n.t(:save_results_message)
    choice = gets.chomp
    result = choice_save_process(choice)
  end

  def choice_save_process(choice)
    check_save(choice)
    command_save.dig(choice.to_sym).call
  end

  def save_game_result
    list = @data.load

    object = {
      name: @@name,
      difficulty: @@level,
      attempts_total: @attempts,
      attempts_used: @@attempts_used,
      hints_total: @hints,
      hints_used: @@hints_used
    }
    array = list.push(object)
    @data.save(array)
  end

  def win(result)
    win_array = Array.new(4, '+')
    return unless result == win_array
    puts I18n.t(:win_game_message)
    @game_end = true
  end

  def registration
    puts I18n.t(:registration)
    @@name = gets.chomp
    check_name(@@name)
  end

  def level_choice
    puts I18n.t(:hard_level)
    @@level = gets.chomp
    check_level(@@level)
  end

  def lost_attempts
    return unless @attempts == @@attempts_used
    puts I18n.t(:lost_game_message)
    @game_end = true
  end

  def attempts_left
    @@attempts_used += 1
  end

  def lost_hints
    return puts I18n.t(:have_no_hints_message) unless @hint_avaliable == true
    puts @process.hint_process(@code)
    @@hints_used += 1
    @hint_avaliable = false if @@hints_used == @hints
  end

  def choice_process(command)
     check_command(command)
     commands_in_game.dig(command.to_sym).call unless command =~ /^[1-6]{4}$/
     @process.turn_process(@code, command)
  end
end
