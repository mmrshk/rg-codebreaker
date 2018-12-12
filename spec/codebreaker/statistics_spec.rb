# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Statistics do
  let(:menu) { Menu.new }

  context 'when testing #stats method' do
    it 'returns stats' do
      expect(menu.data).to receive(:load).and_return([])
      subject.stats(menu.data)
    end
  end

  context 'when testing #stats_sort method' do
    it 'sorts array' do
      players_array = [
        { hints_used: 1, attempts_used: 2 },
        { hints_used: 2, attempts_used: 3 }
      ]
      subject.stats_sort(players_array)
    end
  end

  context 'when testing #difficulty method' do
    it 'returns selected array' do
      list = []
      expect(subject).to receive(:select_difficulty)
      expect(subject).to receive(:stats_sort)
      subject.difficulty(list, Game::HELL)
    end
  end

  context 'when testing #select_difficulty method' do
    it 'returns selected array' do
      list = [{ difficulty: 'hell' }]
      subject.select_difficulty(list, Game::HELL)
    end
  end

  context 'when testing #render_stats' do
    it 'returns list' do
      list = [{
        name: '',
        difficulty: Game::EASY,
        all_attempts: 15,
        attempts_used: 15,
        all_hints: 2,
        hints_used: 0
      }]
      subject.render_stats(list)
    end
  end
end
