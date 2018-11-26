module Validator
  def check_level(level)
    if commands.dig(level.to_sym).nil?
      puts I18n.t(:command_error)
      level_choice
    else
      commands.dig(level.to_sym).call
    end
  end

  def check_name(name)
    if name.nil? || name.length < 3 || name.length > 20
      puts I18n.t(:registration_name_error)
      registration
    end
  end

  def check_save(choice)
    if command_save.dig(choice.to_sym).nil?
      puts I18n.t(:command_error)
      save_result
    end
  end

  def check_command(command)
    if command.to_i != 0 && (command.length != 4 || !(command =~ /^[1-6]{4}$/))
      puts I18n.t(:command_int_error)
      secret_code
    elsif (command.to_i == 0 && commands_in_game.dig(command.to_sym).nil?)
      puts I18n.t(:command_error)
      secret_code
    end
  end
end
