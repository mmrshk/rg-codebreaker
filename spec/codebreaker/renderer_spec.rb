# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Renderer do
  CODE = '1111'
  context 'when #message method' do
    it 'return puts I18n' do
      msg = :start_message
      expect(I18n).to receive(:t).with(:start_message, {})
      subject.message(msg)
    end
  end

  context 'when #start_message method' do
    it 'return start_message' do
      expect(subject).to receive(:message).with(:start_message)
      subject.start_message
    end
  end

  context 'when #rules method' do
    it 'return rules' do
      expect(subject).to receive(:message).with(:rules)
      subject.rules
    end
  end

  context 'when #goodbye_message method' do
    it 'return goodbye_message' do
      expect(subject).to receive(:message).with(:goodbye_message)
      subject.goodbye_message
    end
  end

  context 'when #save_results_message method' do
    it 'return save_results_message' do
      expect(subject).to receive(:message).with(:save_results_message)
      subject.save_results_message
    end
  end

  context 'when #win_game_message method' do
    it 'return win_game_message' do
      expect(subject).to receive(:message).with(:win_game_message)
      subject.win_game_message
    end
  end

  context 'when #promt_to_enter_secret_code_hint_exit method' do
    it 'return promt_to_enter_secret_code_hint_exit' do
      expect(subject).to receive(:message).with(:promt_to_enter_secret_code_hint_exit)
      subject.promt_to_enter_secret_code_hint_exit
    end
  end

  context 'when #lost_game_message method' do
    it 'return lost_game_message' do
      expect(subject).to receive(:message).with(:lost_game_message, { code: CODE })
      subject.lost_game_message(CODE)
    end
  end

  context 'when #success_save_message method' do
    it 'return success_save_message' do
      expect(subject).to receive(:message).with(:success_save_message)
      subject.success_save_message
    end
  end

  context 'when #no_hints_message? method' do
    it 'return no_hints_message?' do
      expect(subject).to receive(:message).with(:have_no_hints_message)
      subject.no_hints_message?
    end
  end

  context 'when #digit_on_place method' do
    it 'return digit_on_place' do
      expect(subject).to receive(:message).with(:digit_on_place, code: CODE)
      subject.digit_on_place(CODE)
    end
  end

  context 'when #registration_name_emptyness_error method' do
    it 'return registration_name_emptyness_error' do
      expect(subject).to receive(:message).with(:registration_name_emptyness_error)
      subject.registration_name_emptyness_error
    end
  end

  context 'when #registration_name_length_error method' do
    it 'return registration_name_length_error' do
      expect(subject).to receive(:message).with(:registration_name_length_error)
      subject.registration_name_length_error
    end
  end

  context 'when #command_error method' do
    it 'return command_error' do
      expect(subject).to receive(:message).with(:command_error)
      subject.command_error
    end
  end

  context 'when #command_length_error method' do
    it 'return command_length_error' do
      expect(subject).to receive(:message).with(:command_length_error)
      subject.command_length_error
    end
  end

  context 'when #command_int_error method' do
    it 'return command_int_error' do
      expect(subject).to receive(:message).with(:command_int_error)
      subject.command_int_error
    end
  end
end
