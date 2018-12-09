# frozen_string_literal: true

require 'spec_helper'
require "pry"

RSpec.describe Game do
  CODE = '1111'

  context 'testing #generate method' do
    it 'checks that number mathes regex template' do
      expect(subject.generate.join).to match(/^[1-6]{#{Game::WIN_ARRAY_LENGTH}}$/)
    end

    it 'returns array of integers' do
      code_array = subject.generate
      int_array = code_array.select { |x| x.is_a? Integer }
      expect(code_array).to eq int_array
    end
  end

  context 'used #attempts_left method' do
    it 'decreases attempts by one when used' do
      attempts = 3
      subject.instance_variable_set(:@attempts, 3)
      expect(subject.attempts_left).to eq attempts - 1
    end
  end

  context 'when #check_for_lose method' do
    it 'returns lost_game_message when attempts not eq to zero' do
      subject.instance_variable_set(:@attempts, 1)
      subject.check_for_lose
    end
  end

  context 'when #generate_game method' do
    it 'returns message' do
      initial_params = Game::DIFFICULTIES[Game::EASY.to_sym]
      expect(I18n).to receive(:t).with(initial_params[:msg_name], {})
      subject.generate_game(hints: initial_params[:hints], attempts: initial_params[:attempts], msg_name: initial_params[:msg_name])
    end
  end

  context 'when #turn_process method' do
    it do
      process = subject.instance_variable_get(:@process)
      win_code = Array.new(Game::WIN_ARRAY_LENGTH, '+')
      subject.instance_variable_set(:@code, win_code)
      expect(process).to receive(:turn_process).with(win_code, CODE).once
      subject.start_process(CODE)
    end
  end
end
