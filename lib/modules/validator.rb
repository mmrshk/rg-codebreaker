# frozen_string_literal: true

module Validator
  VALUE_FORMAT = /^[1-6]{4}$/.freeze

  def check_emptyness(name)
    !name.empty?
  end

  def check_length(name)
    name.size.between?(3, 20)
  end

  def check_command_range(command)
    return true if command =~ VALUE_FORMAT
  end

  def string_of_int?(command)
    !command.to_i.zero?
  end
end
