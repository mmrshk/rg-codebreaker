# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Menu do
  context 'when testing #start_game method' do
    it 'returns @game.new_game' do
      expect_any_instance_of(Game).to receive :new_game
      subject.start_game
    end
  end

  context 'when testing #rules' do
    it 'calls rules message' do
      expect(I18n).to receive(:t).with(:rules)
      expect(subject).to receive(:game_menu)
      subject.rules
    end
  end

  context 'when testing #stats_sort method' do
    it 'sorts array' do
      array = [
        { hints_used: 1, attempts_used: 2 },
        { hints_used: 2, attempts_used: 3 }
      ]
      subject.stats_sort(array)
    end
  end

  context 'when testing #difficulty method' do
    it 'returns selected array' do
      list = []
      difficulty = 'hell'
      expect(subject).to receive(:select_difficulty)
      expect(subject).to receive(:stats_sort)
      subject.difficulty(list, difficulty)
    end
  end

  context 'when testing #select_difficulty method' do
    it 'returns selected array' do
      list = [{ difficulty: 'hell' }]
      difficulty = 'hell'
      subject.select_difficulty(list, difficulty)
    end
  end

  context 'when testing #stats method' do
    it 'returns stats' do
      expect(subject.instance_variable_get(:@data)).to receive(:load).and_return([])
      expect(subject).to receive(:game_menu)
      subject.stats
    end
  end

  context 'when testing #exit_from_game method' do
    it 'returns message' do
      expect(I18n).to receive(:t).with(:goodbye_message)
      expect(subject).to receive(:exit)
      subject.exit_from_game
    end
  end

  context 'when testing #choice_processor method' do
    it 'calls inputed method' do
      command_name = 'exit'
      expect(subject).to receive(:main_commands)
      subject.choice_process(command_name)
    end
  end
end
