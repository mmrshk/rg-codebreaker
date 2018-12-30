# frozen_string_literal: true

require 'spec_helper'

class DummyClass
  include Codebreaker::Modules::Validator
end

RSpec.describe DummyClass do
  let(:invalid_range) { (7..9) }
  let(:valid_name) { 'a' * rand(3..20) }
  let(:empty_name) { '' }
  let(:code_valid) { Array.new(Codebreaker::Entities::Game::DIGITS_COUNT) { rand(Codebreaker::Entities::Game::RANGE) } }
  let(:code_unvalid) { Array.new(Codebreaker::Entities::Game::DIGITS_COUNT) { rand(invalid_range) } }

  context 'testing #check_emptyness method' do
    it 'returns true when name not empty' do
      expect(subject.check_emptyness(valid_name)).to be false
    end

    it 'returns false' do
      expect(subject.check_emptyness(empty_name)).to be true
    end
  end

  context 'testing #check_name_length method' do
    it 'returns true' do
      expect(subject.check_length(valid_name, Codebreaker::Entities::Menu::MIN_SIZE_VALUE,
                                  Codebreaker::Entities::Menu::MAX_SIZE_VALUE)).to be true
    end

    it 'returns false' do
      expect(subject.check_length(empty_name, Codebreaker::Entities::Menu::MIN_SIZE_VALUE,
                                  Codebreaker::Entities::Menu::MAX_SIZE_VALUE)).to be false
    end
  end

  context 'testing #check_command_range method' do
    it 'return true' do
      expect(subject.check_command_range(code_valid.join)).to be_zero
    end

    it 'return false' do
      expect(subject.check_command_range(code_unvalid.join)).to be nil
    end
  end
end
