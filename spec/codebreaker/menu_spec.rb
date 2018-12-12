# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Menu do
  let(:statistics) { Statistics.new }
  let(:command) { '1111' }
  CHAR = 'w'

  context 'when testing #game_menu method' do
    it 'works with choice_options' do
      expect(subject.data).to receive(:storage_exist?)
      expect(subject.data).to receive(:create)
      expect(subject.renderer).to receive(:start_message)
      expect(subject.renderer).to receive(:choice_options)
      allow(subject).to receive(:gets).and_return('')
      expect(subject).to receive(:choice_menu_process).once
      subject.game_menu
    end
  end

  context 'when #registration method' do
    it 'gets name of user' do
      expect(subject.renderer).to receive(:registration)
      allow(subject).to receive(:gets).and_return('Nika')
      expect(subject).to receive(:check_name).once
      subject.registration
    end
  end

  context 'when testing #rules' do
    it 'calls rules message' do
      expect(subject.renderer).to receive(:rules)
      expect(subject).to receive(:game_menu)
      subject.rules
    end
  end

  context 'when testing #exit_from_game method' do
    it 'returns message' do
      expect(subject.renderer).to receive(:goodbye_message)
      expect(subject).to receive(:exit)
      subject.exit_from_game
    end
  end

  context 'when testing #new_game method' do
    it do
      expect(subject).to receive(:registration)
      expect(subject).to receive(:level_choice)
      expect(subject).to receive(:secret_code)
      subject.new_game
    end
  end

  context 'when testing #save_result method' do
    it 'expexts the choice of user' do
      expect(subject.renderer).to receive(:save_results_message)
      allow(subject).to receive(:gets).and_return(Menu::YES.to_s)
      expect(subject).to receive(:choice_save_process).once
      subject.save_result
    end
  end

  context 'when testing #stats method' do
    it 'returns stats' do
      statistics = subject.instance_variable_get(:@statistics)
      expect(statistics).to receive(:stats).with(subject.data)
      expect(subject).to receive(:game_menu)
      subject.stats
    end
  end

  context 'when testing #level_choice method' do
    it 'checks input of user' do
      expect(subject.renderer).to receive(:hard_level)
      allow(subject).to receive(:gets).and_return(Game::HELL.to_s)
      expect(subject).to receive(:choose_level).once
      subject.level_choice
    end
  end

  context 'when testing #win method' do
    it 'returns nil' do
      result = '+++-'
      expect(subject.win(result)).to be nil
    end

    it 'returns #win_game_message' do
      result = '++++'
      expect(subject.win(result)).to be true
      expect(subject.renderer).to receive(:win_game_message)
      expect(subject.win(result)).to be true
    end
  end

  context 'when #check_for_lose method' do
    it 'returns lost_game_message when attempts not eq to zero' do
      subject.game.instance_variable_set(:@attempts, 1)
      expect(subject.check_for_lose).to be nil
    end

    it 'returns nil' do
      subject.game.instance_variable_set(:@attempts, 0)
      expect(subject.check_for_lose).to be false
    end
  end

  context 'when testing #choice_menu_process' do
    it 'returns #start_game' do
      allow(subject).to receive(:gets).and_return(Game::HELL.to_s)
      expect(subject).to receive(:new_game)
      subject.choice_menu_process(Menu::START.to_s)
    end

    it 'returns #exit_from_game' do
      allow(subject).to receive(:gets).and_return(Game::HELL.to_s)
      expect(subject).to receive(:exit_from_game)
      subject.choice_menu_process(Menu::EXIT.to_s)
    end

    it 'returns #rules' do
      allow(subject).to receive(:gets).and_return(Game::HELL.to_s)
      expect(subject).to receive(:rules)
      subject.choice_menu_process(Menu::RULES.to_s)
    end

    it 'returns #stats' do
      allow(subject).to receive(:gets).and_return(Game::HELL.to_s)
      expect(subject).to receive(:stats)
      subject.choice_menu_process(Menu::STATS.to_s)
    end

    it 'returns command_error' do
      allow(subject).to receive(:gets).and_return(Game::HELL.to_s)
      expect(subject.renderer).to receive(:command_error)
      expect(subject).to receive(:game_menu)
      subject.choice_menu_process(Menu::STATS.to_s + CHAR)
    end
  end

  context 'when testing #choose_level' do
    it 'generates easy game' do
      allow(subject).to receive(:gets).and_return(Game::EASY)
      expect(subject).to receive(:call_generate_game).with(Game::EASY)
      subject.choose_level(Game::EASY)
    end

    it 'generates medium game' do
      allow(subject).to receive(:gets).and_return(Game::MEDIUM)
      expect(subject).to receive(:call_generate_game).with(Game::MEDIUM)
      subject.choose_level(Game::MEDIUM)
    end

    it 'generates hell game' do
      allow(subject).to receive(:gets).and_return(Game::HELL)
      expect(subject).to receive(:call_generate_game).with(Game::HELL)
      subject.choose_level(Game::HELL)
    end

    it 'returns #game_menu' do
      allow(subject).to receive(:gets).and_return(Menu::EXIT.to_s)
      expect(subject).to receive(:exit_from_game)
      subject.choose_level(Menu::EXIT)
    end

    it 'generates easy_game' do
      allow(subject).to receive(:gets).and_return(Game::HELL)
      expect(subject).to receive(:check_level)
      subject.choose_level(Menu::STATS.to_s + CHAR)
    end
  end

  context 'when testing #game_operations method' do
    it 'returns #lost_hints' do
      allow(subject).to receive(:gets).and_return(Menu::EXIT.to_s)
      expect(subject).to receive(:lost_hints)
      subject.game_operations(Menu::HINT.to_s)
    end

    it 'returns #check_command' do
      allow(subject).to receive(:gets).and_return([])
      expect(subject).to receive(:check_command)
      subject.game_operations(Menu::STATS.to_s + CHAR)
    end
  end

  context 'when testing #choice_save_process method' do
    it 'returns save_game_result' do
      allow(subject).to receive(:gets).and_return(Menu::EXIT.to_s)
      expect(subject).to receive(:save_game_result)
      subject.choice_save_process(Menu::YES.to_s)
    end

    it 'returns check_save' do
      expect(subject).to receive(:check_save)
      subject.choice_save_process(Menu::EXIT.to_s + CHAR)
    end
  end

  context 'when testing #call_generate_game' do
    it do
      difficulty = Game::EASY
      expect(subject.game).to receive(:generate_game).with(Game::DIFFICULTIES[difficulty])
      subject.call_generate_game(difficulty)
    end
  end

  context 'when testing #choice_code_process' do
    it do
      expect(subject).to receive(:game_operations).with(command)
      expect(subject.game).to receive(:start_process).with(command)
      subject.choice_code_process(command)
    end
  end
end
