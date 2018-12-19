# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Game do
  LOSE_RESULT = '-+++'
  let(:start_code) { '1111' }
  let(:hints_array) { [1, 2] }
  let(:valid_name) { 'a' * rand(3..20) }
  let(:code) { [1, 2, 3, 4]}

  context 'when testing #take_a_hint! method' do
    it 'returnes last el of hints array' do
      subject.instance_variable_set(:@hints, hints_array)
      expected_value = subject.hints.last
      expect(subject.take_a_hint!).to eq expected_value
    end
  end

  context 'testing #generate_secret_code method' do
    it 'checks that number mathes regex template' do
      secret_code = subject.send(:generate_secret_code).join
      expect(secret_code).to match(/^[1-6]{#{Game::DIGITS_COUNT}}$/)
    end

    it 'returns array of integers' do
      code_array = subject.send(:generate_secret_code)
      int_array = code_array.select { |x| x.is_a? Integer }
      expect(code_array).to eq int_array
    end
  end

  context 'when #generate method' do
    it 'returns message' do
      initial_params = Game::DIFFICULTIES[:easy]
      hints = code.sample(initial_params[:hints])
      subject.instance_variable_set(:@attempts, initial_params[:attempts])
      subject.instance_variable_set(:@hints, hints)
      expect(subject.attempts).to eq initial_params[:attempts]
      expect(subject.hints).to eq hints
      subject.generate(hints: initial_params[:hints], attempts: initial_params[:attempts])
    end
  end

  context 'when #start_process method' do
    it do
      process = subject.instance_variable_get(:@process)
      win_code = Array.new(Game::DIGITS_COUNT, '+')
      subject.instance_variable_set(:@code, win_code)
      expect(process).to receive(:secret_code_proc).with(win_code.join, start_code).once
      subject.start_process(start_code)
    end
  end

  context 'when testing #calculate method' do
    it 'calculates param tries' do
      difficulty = Game::DIFFICULTIES.keys.first
      subject.instance_variable_set(:@attempts, 2)
      subject.instance_variable_set(:@hints, hints_array)
      calculated = { tries: Game::DIFFICULTIES[difficulty.to_sym][:attempts] - subject.attempts,
                     suggestions: Game::DIFFICULTIES[difficulty.to_sym][:hints] - subject.hints.length}
      expected_calculated = { tries: 13, suggestions: 0}
      expect(calculated).to eq expected_calculated
      subject.calculate(:tries, difficulty)
    end
  end

  context 'used #decrease_attempts! method' do
    it 'decreases attempts by one when used' do
      attempts = 3
      subject.instance_variable_set(:@attempts, 3)
      expect(subject.decrease_attempts!).to eq attempts - 1
    end
  end

  context 'when testing #hints_spent? method' do
    it 'returns true' do
      subject.instance_variable_set(:@hints, [])
      expect(subject.hints_spent?).to be true
    end

    it 'returns false' do
      subject.instance_variable_set(:@hints, [1, 2])
      expect(subject.hints_spent?).to be false
    end
  end

  context 'when testing #win? method' do
    it 'returns true' do
      expect(subject.win?(Game::WIN_RESULT)).to be true
    end

    it 'returns false' do
      expect(subject.win?(LOSE_RESULT)).to be false
    end
  end

  context 'when testing #to_h method' do
    it 'returns hash' do
      subject.instance_variable_set(:@attempts, 2)
      subject.instance_variable_set(:@hints, hints_array)
      expect(subject.to_h(valid_name, Game::DIFFICULTIES.keys.first).is_a?(Hash)).to be true
    end
  end
end
