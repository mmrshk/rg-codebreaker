# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Validator do
  let(:valid_name) { 'a'*rand(3..20) }
  EMPTY_NAME = ''
  INVALID_RANGE = 7..9
  ZERO = 0

  let(:menu) { Menu.new }
  let(:code_valid) { Array.new(Game::DIGITS_COUNT) { rand(Game::RANGE) } }
  let(:code_unvalid) { Array.new(Game::DIGITS_COUNT) { rand(INVALID_RANGE) } }

  context 'testing #check_emptyness method' do
    it 'returns true when name not empty' do
      expect(menu.check_emptyness(valid_name)).to be false
    end

    it 'returns false' do
      expect(menu.check_emptyness(EMPTY_NAME)).to be true
    end
  end

  context 'testing #check_name_length method' do
    it 'returns true' do
      expect(menu.check_length(valid_name)).to be true
    end

    it 'returns false' do
      expect(menu.check_length(EMPTY_NAME)).to be false
    end
  end

  context 'testing #check_command_range method' do
    it 'return true' do
      expect(menu.check_command_range(code_valid.join)).to be ZERO
    end

    it 'return false' do
      expect(menu.check_command_range(code_unvalid.join)).to be nil
    end
  end
end
