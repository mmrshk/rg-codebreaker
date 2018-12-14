# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Validator do
  let(:menu) { Menu.new }
  VALID_NAME = 'a'*rand(3..20)
  EMPTY_NAME = ''
  INVALID_RANGE = 7..9
  let(:code_valid) { Array.new(Game::DIGITS_COUNT) { rand(Game::RANGE) } }
  let(:code_unvalid) { Array.new(Game::DIGITS_COUNT) { rand(INVALID_RANGE) } }

  context 'testing #check_emptyness method' do
    it 'returns true when name not empty' do
      expect(menu.check_emptyness(VALID_NAME)).to be true
    end

    it 'returns false' do
      expect(menu.check_emptyness(EMPTY_NAME)).to be false
    end
  end

  context 'testing #check_name_length method' do
    it 'returns true' do
      expect(menu.check_length(VALID_NAME)).to be true
    end

    it 'returns false' do
      expect(menu.check_length(EMPTY_NAME)).to be false
    end
  end

  context 'testing #check_command_range method' do
    it 'return true' do
      expect(menu.check_command_range(code_valid.join)).to be true
    end

    it 'return false' do
      expect(menu.check_command_range(code_unvalid.join)).to be nil
    end
  end
end
