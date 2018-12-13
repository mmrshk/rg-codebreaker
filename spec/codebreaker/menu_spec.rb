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
      allow(subject).to receive(:gets).and_return('')
      expect(subject).to receive(:choice_menu_process).once
      subject.game_menu
    end
  end

  context 'when testing #choice_code_process' do
    it do
      expect(subject).to receive(:game_operations).with(command)
      expect(subject.game).to receive(:start_process).with(command)
      subject.send(:choice_code_process, command)
    end
  end

  context 'when testing #new_game method' do
    it do
      expect(subject).to receive(:registration)
      expect(subject).to receive(:level_choice)
      expect(subject).to receive(:secret_code)
      subject.send(:new_game)
    end
  end

  context 'when #registration method' do
    it 'gets name of user' do
      allow(subject).to receive(:gets).and_return(CHAR * 4)
      subject.send(:registration)
    end
  end

  context 'when testing #rules' do
    it 'calls rules message' do
      expect(subject.renderer).to receive(:rules)
      expect(subject).to receive(:game_menu)
      subject.send(:rules)
    end
  end

  context 'when testing #exit_from_game method' do
    it 'returns message' do
      expect(subject.renderer).to receive(:goodbye_message)
      expect(subject).to receive(:exit)
      subject.send(:exit_from_game)
    end
  end

  context 'when testing #save_result method' do
    it 'expexts the choice of user' do
      allow(subject).to receive(:gets).and_return(Menu::YES.to_s)
      expect(subject).to receive(:choice_save_process)
      subject.send(:save_result)
    end
  end

  context 'when testing #stats method' do
    it 'returns stats' do
      statistics = subject.instance_variable_get(:@statistics)
      expect(statistics).to receive(:stats).with(subject.data)
      expect(subject).to receive(:game_menu)
      subject.send(:stats)
    end
  end

  context 'when testing #level_choice method' do
    it 'checks input of user' do
      allow(subject).to receive(:gets).and_return(Game::HELL.to_s)
      subject.send(:level_choice)
    end
  end

  context 'when testing #win method' do
    it 'returns nil' do
      result = '+++-'
      expect(subject.send(:win, result)).to be nil
    end

    it 'returns #win_game_message' do
      result = '++++'
      expect(subject.send(:win, result)).to be true
      expect(subject.renderer).to receive(:win_game_message)
      expect(subject.send(:win, result)).to be true
    end
  end

  context 'when #lose? method' do
    it 'returns lost_game_message when attempts not eq to zero' do
      subject.game.instance_variable_set(:@attempts, 1)
      expect(subject.send(:lose?)).to be nil
    end

    it 'returns nil' do
      subject.game.instance_variable_set(:@attempts, 0)
      expect(subject.send(:lose?)).to be false
    end
  end

  context 'when testing #choice_menu_process' do
    it 'returns #start_game' do
      allow(subject).to receive(:gets).and_return(Game::HELL.to_s)
      expect(subject).to receive(:new_game)
      subject.send(:choice_menu_process, Menu::START.to_s)
    end

    it 'returns #exit_from_game' do
      allow(subject).to receive(:gets).and_return(Game::HELL.to_s)
      expect(subject).to receive(:exit_from_game)
      subject.send(:choice_menu_process, Menu::EXIT.to_s)
    end

    it 'returns #rules' do
      allow(subject).to receive(:gets).and_return(Game::HELL.to_s)
      expect(subject).to receive(:rules)
      subject.send(:choice_menu_process, Menu::RULES.to_s)
    end

    it 'returns #stats' do
      allow(subject).to receive(:gets).and_return(Game::HELL.to_s)
      expect(subject).to receive(:stats)
      subject.send(:choice_menu_process, Menu::STATS.to_s)
    end

    it 'returns command_error' do
      allow(subject).to receive(:gets).and_return(Game::HELL.to_s)
      expect(subject.renderer).to receive(:command_error)
      expect(subject).to receive(:game_menu)
      subject.send(:choice_menu_process, Menu::STATS.to_s + CHAR)
    end
  end

  context 'when testing #choose_level' do
    it 'generates easy game' do
      allow(subject).to receive(:gets).and_return(Game::EASY)
      expect(subject).to receive(:call_generate_game).with(Game::EASY)
      subject.send(:choose_level, Game::EASY)
    end

    it 'generates medium game' do
      allow(subject).to receive(:gets).and_return(Game::MEDIUM)
      expect(subject).to receive(:call_generate_game).with(Game::MEDIUM)
      subject.send(:choose_level, Game::MEDIUM)
    end

    it 'generates hell game' do
      allow(subject).to receive(:gets).and_return(Game::HELL)
      expect(subject).to receive(:call_generate_game).with(Game::HELL)
      subject.send(:choose_level, Game::HELL)
    end

    it 'returns #game_menu' do
      allow(subject).to receive(:gets).and_return(Menu::EXIT.to_s)
      expect(subject).to receive(:exit_from_game)
      subject.send(:choose_level, Menu::EXIT)
    end

    it 'returns command_error' do
      allow(subject).to receive(:gets).and_return(Game::HELL)
      expect(subject).to receive(:level_choice)
      expect(subject.renderer).to receive(:command_error)
      subject.send(:choose_level, Menu::STATS.to_s + CHAR)
    end
  end

  context 'when testing #game_operations method' do
    it 'returns #lost_hints' do
      allow(subject).to receive(:gets).and_return(Menu::EXIT.to_s)
      expect(subject).to receive(:lost_hints)
      subject.send(:game_operations, Menu::HINT.to_s)
    end

    it 'returns #check_command' do
      allow(subject).to receive(:gets).and_return([])
      expect(subject).to receive(:valid_command?)
      subject.send(:game_operations, Menu::STATS.to_s + CHAR)
    end
  end

  context 'when testing #choice_save_process method' do
    it 'returns save_game_result' do
      allow(subject).to receive(:gets).and_return(Menu::EXIT.to_s)
      expect(subject).to receive(:save_game_result)
      subject.send(:choice_save_process, Menu::YES.to_s)
    end

    it 'returns #save_result' do
      allow(subject).to receive(:gets).and_return(Menu::EXIT.to_s + CHAR)
      expect(subject.renderer).to receive(:command_error)
      expect(subject).to receive(:save_result)
      subject.send(:choice_save_process, Menu::EXIT.to_s + CHAR)
    end
  end

end
