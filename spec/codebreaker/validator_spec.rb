# frozen_string_literal: true

require 'spec_helper'

class ValidatorTest
  include Validator
end

RSpec.describe Validator do
  INVALID_RANGE = (7..9).freeze
  let(:validator_test) { ValidatorTest.new }
  let(:valid_name) { 'a' * rand(3..20) }
  let(:empty_name) { '' }
  let(:code_valid) { Array.new(Game::DIGITS_COUNT) { rand(Game::RANGE) } }
  let(:code_unvalid) { Array.new(Game::DIGITS_COUNT) { rand(INVALID_RANGE) } }

  context 'testing #check_emptyness method' do
    it 'returns true when name not empty' do
      expect(validator_test.check_emptyness(valid_name)).to be false
    end

    it 'returns false' do
      expect(validator_test.check_emptyness(empty_name)).to be true
    end
  end

  context 'testing #check_name_length method' do
    it 'returns true' do
      expect(validator_test.check_length(valid_name)).to be true
    end

    it 'returns false' do
      expect(validator_test.check_length(empty_name)).to be false
    end
  end

  context 'testing #check_command_range method' do
    it 'return true' do
      expect(validator_test.check_command_range(code_valid.join)).to be_zero
    end

    it 'return false' do
      expect(validator_test.check_command_range(code_unvalid.join)).to be nil
    end
  end
end
