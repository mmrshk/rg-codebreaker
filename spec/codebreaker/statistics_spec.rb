# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Statistics do
  let(:menu) { Menu.new }

  context 'when testing #stats method' do
    let(:player_1)  { {
        name: '',
        difficulty: Game::DIFFICULTIES.keys.first,
        all_attempts: 15,
        attempts_used: 10,
        all_hints: 2,
        hints_used: 0
      }
    }
    let(:player_2) { {
        name: '',
        difficulty: Game::DIFFICULTIES.keys.first,
        all_attempts: 15,
        attempts_used: 15,
        all_hints: 2,
        hints_used: 0
      }
    }
    let(:player_3)  { {
        name: '',
        difficulty: Game::DIFFICULTIES.keys.first,
        all_attempts: 15,
        attempts_used: 5,
        all_hints: 2,
        hints_used: 0
      }
    }

    it 'returns stats' do
      expect(menu.data).to receive(:load).and_return([player_1, player_2, player_3])
      expect(subject.stats(menu.data)).to eq [player_2, player_1, player_3]
    end
  end
end
