# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Game do
  CODE = '1111'

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

  context 'when #generate_game method' do
    it 'returns message' do
      initial_params = Game::DIFFICULTIES[Game::EASY.to_sym]
      subject.generate_game(hints: initial_params[:hints], attempts: initial_params[:attempts])
    end
  end

  context 'when #start_process method' do
    it do
      process = subject.instance_variable_get(:@process)
      win_code = Array.new(Game::DIGITS_COUNT, '+')
      subject.instance_variable_set(:@code, win_code)
      expect(process).to receive(:secret_code_proc).with(win_code.join, CODE).once
      subject.start_process(CODE)
    end
  end

  context 'when testing #calculate method' do
    it 'calculates param tries' do
      subject.instance_variable_set(:@attempts, 2)
      subject.instance_variable_set(:@hints, [1, 2])
      subject.calculate(:tries, Game::EASY)
    end
  end

  context 'used #decrease_attempts method' do
    it 'decreases attempts by one when used' do
      attempts = 3
      subject.instance_variable_set(:@attempts, 3)
      expect(subject.decrease_attempts).to eq attempts - 1
    end
  end
end
