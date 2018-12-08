# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Validator do
  context 'when testing #message' do
    it 'returns message' do
      menu = Menu.new
      msg_name = :registration
      expect(I18n).to receive(:t).with(msg_name, {})
      menu.message(msg_name)
    end
  end

  context 'testing #check_level method' do
    it 'returns message command_error' do
      game = Game.new
      expect(I18n).to receive(:t).with(:command_error, {})
      expect(game).to receive(:level_choice).once
      game.check_level
    end
  end

  context 'when testing #check_name method' do
    it 'returns registration_name_error message' do
      game = Game.new
      name = 'a'
      expect(I18n).to receive(:t).with(:registration_name_error, {})
      expect(game).to receive(:registration).once
      game.check_name(name)
    end
  end

  context 'when testing #check_save method' do
    it 'returns command_error message' do
      game = Game.new
      expect(I18n).to receive(:t).with(:command_error, {})
      expect(game).to receive(:save_result).once
      game.check_save
    end
  end

  context 'when testing #check_command method' do
    it 'returns message command_int_error' do
      #constant = "1111" + 1 
      game = Game.new
      command = '111111'
      expect(I18n).to receive(:t).with(:command_int_error, {})
      expect(game).to receive(:secret_code).once
      game.check_command(command)
    end

    it 'returns message command_error' do
      game = Game.new
      command = 'exittt'
      expect(I18n).to receive(:t).with(:command_error, {})
      expect(game).to receive(:secret_code).once
      game.check_command(command)
    end
  end
end
