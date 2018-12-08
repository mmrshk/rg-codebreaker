# frozen_string_literal: true

module Validator
  def check_level
    renderer.command_error
    level_choice
  end

  def check_name(name)
    registration unless check_name_emptyness(name) == true && check_name_length(name) == true
  end

  def check_name_emptyness(name)
    return true unless name.empty?

    renderer.registration_name_emptyness_error
  end

  def check_name_length(name)
    return true if name.size.between?(3,20)

    renderer.registration_name_length_error
  end

  def check_save
    renderer.command_error
    save_result
  end

  def check_command(command)
    if command.to_i.zero?
      renderer.command_error
      secret_code
    else
      check_command_length(command)
      check_command_range(command)
    end
  end

  def check_command_length(command)
    return true if command.length == 4

    renderer.command_length_error
    secret_code
  end

  def check_command_range(command)
    return true if command =~ /^[1-6]{4}$/

    renderer.command_int_error
    secret_code
  end
end
