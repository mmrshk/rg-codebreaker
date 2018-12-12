# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Validator do
  let(:menu) { Menu.new }
  VALID_NAME = 'Emma'
  EMPTY_NAME = ''
  EXIT = 'exit'
  NO = 'no'
  CODE_V = '1111'
  CODE_UNVALID = '7678'

  context 'testing #check_level method' do
    it 'returns message command_error' do
      expect(I18n).to receive(:t).with(:command_error, {})
      expect(menu).to receive(:level_choice)
      menu.check_level
    end
  end

  context 'testing #check_name method' do
    it 'call registration method if name valid' do
      expect(menu).to receive(:check_name_emptyness).with(VALID_NAME).and_return(true)
      expect(menu).to receive(:check_name_length).with(VALID_NAME).and_return(true)
      menu.check_name(VALID_NAME)
    end
  end

  context 'testing #check_name_emptyness method' do
    it 'returns true when name not empty' do
      expect(menu.check_name_emptyness(VALID_NAME)).to be true
    end

    it 'returns registration_name_emptyness_error' do
      expect(menu.check_name_emptyness(EMPTY_NAME)).to be nil
      expect(menu.renderer).to receive(:registration_name_emptyness_error)
      menu.check_name_emptyness(EMPTY_NAME)
    end
  end

  context 'testing #check_name_length method' do
    it 'call registration method if name valid' do
      expect(menu.check_name_emptyness(VALID_NAME)).to be true
      menu.check_name_length(VALID_NAME)
    end

    it 'returns registration_name_length_error' do
      expect(menu.check_name_emptyness(EMPTY_NAME)).to be nil
      expect(menu.renderer).to receive(:registration_name_length_error)
      menu.check_name_length(EMPTY_NAME)
    end
  end

  context 'testing #check_command_length method' do
    it 'return true' do
      expect(menu.check_command_length(CODE_V)).to be true
      menu.check_command_length(CODE_V)
    end
  end

  context 'testing #check_command_range method' do
    it 'return true' do
      expect(menu.check_command_range(CODE_V)).to be true
      menu.check_command_range(CODE_V)
    end
  end

  context 'testing #check_command method' do
    it 'return command_error' do
      command = 'w'
      expect(menu.renderer).to receive(:command_error).once
      expect(menu).to receive(:secret_code).once
      menu.check_command(command)
    end

    it 'returns registration_name_length_error' do
      expect(menu).to receive(:check_command_length)
      expect(menu).to receive(:check_command_range)
      menu.check_command(CODE_V)
    end
  end
end
