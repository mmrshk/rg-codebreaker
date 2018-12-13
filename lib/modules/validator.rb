# frozen_string_literal: true

module Validator
  def check_name_emptyness(name)
    return true unless name.empty?
  end

  def check_name_length(name)
    return true if name.size.between?(3, 20)
  end

  def check_command_range(command)
    return true if command =~ /^[1-6]{4}$/
  end
end
