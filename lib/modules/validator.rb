# frozen_string_literal: true

module Validator
  def check_level
    message(:command_error)
    level_choice
  end

  def check_name(name)
    return unless name.nil? || name.length < 3 || name.length > 20

    message(:registration_name_error)
    registration
  end

  def check_save
    message(:command_error)
    save_result
  end

  def check_command(command)
    if command.to_i != 0 && (command.length != 4 || command !~ /^[1-6]{4}$/)
      message(:command_int_error)
      secret_code
    elsif command.to_i.zero?
      message(:command_error)
      secret_code
    end
  end

  def message(msg_name)
    I18n.t(msg_name)
  end
end
