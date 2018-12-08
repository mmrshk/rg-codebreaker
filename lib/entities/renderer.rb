# frozen_string_literal: true

class Renderer
  def message(msg_name, hashee = {})
    puts I18n.t(msg_name, **hashee)
  end

  def start_message
    message(:start_message)
  end

  def choice_options
    message(:choice_options)
  end

  def rules
    message(:rules)
  end

  def goodbye_message
    message(:goodbye_message)
  end

  def save_results_message
    message(:save_results_message)
  end

  def win_game_message
    message(:win_game_message)
  end

  def registration
    message(:registration)
  end

  def hard_level
    message(:hard_level)
  end

  def promt_to_enter_secret_code_hint_exit
    message(:promt_to_enter_secret_code_hint_exit)
  end

  def lost_game_message(code)
    message(:lost_game_message, code: code)
  end

  def success_save_message
    message(:success_save_message)
  end

  def no_hints_message?
    message(:have_no_hints_message)
  end

  def digit_on_place(code)
    message(:digit_on_place, code: code)
  end

  def registration_name_emptyness_error
    message(:registration_name_emptyness_error)
  end

  def registration_name_length_error
    message(:registration_name_length_error)
  end

  def command_error
    message(:command_error)
  end

  def command_length_error
    message(:command_length_error)
  end

  def command_int_error
    message(:command_int_error)
  end
end
