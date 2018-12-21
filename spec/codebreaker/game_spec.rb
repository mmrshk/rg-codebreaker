# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Game do
  let(:lose_result) { '-+++' }
  let(:start_code) { '1111' }
  let(:hints_array) { [1, 2] }
  let(:valid_name) { 'a' * rand(3..20) }
  let(:code) { [1, 1, 1, 1] }

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
  end

  context 'when #generate method' do
    it do
      difficulty = Game::DIFFICULTIES.keys.first
      expect(subject).to receive(:generate_secret_code).and_return(code)
      subject.generate(difficulty)
      expect(subject.attempts).to eq Game::DIFFICULTIES[difficulty][:attempts]
      expect(subject.instance_variable_get(:@level)).to eq difficulty
      expect(code).to include(*subject.instance_variable_get(:@hints))
    end
  end

  context 'when #start_process method' do
    it do
      process = subject.instance_variable_get(:@process)
      win_code = Array.new(Game::DIGITS_COUNT, Processor::MATCHED_DIGIT_CHAR)
      subject.instance_variable_set(:@code, win_code)
      expect(process).to receive(:secret_code_proc).with(win_code.join, start_code)
      subject.start_process(start_code)
    end
  end

  context 'when testing #calculate method' do
    it 'calculates param tries' do
      subject.instance_variable_set(:@level, Game::DIFFICULTIES.keys.first)
      subject.instance_variable_set(:@attempts, 2)
      subject.instance_variable_set(:@hints, hints_array)
      expected_calculated = { attempts_used: 13, hints_used: 0 }
      expect(subject.calculate).to eq expected_calculated
    end
  end

  context 'used #decrease_attempts! method' do
    it 'decreases attempts by one when used' do
      subject.instance_variable_set(:@attempts, 3)
      expect { subject.decrease_attempts! }.to change(subject, :attempts).by(-1)
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

  context 'when testing #to_h method' do
    it 'returns hash' do
      subject.instance_variable_set(:@level, Game::DIFFICULTIES.keys.first)
      subject.instance_variable_set(:@attempts, 2)
      subject.instance_variable_set(:@hints, hints_array)
      expect(subject.to_h(valid_name)).to be_an_instance_of(Hash)
    end
  end
end
