# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Menu do
  HINTS_ARRAY = [1, 2]

  let(:statistics) { Statistics.new }
  let(:command) { '1111' }
  let(:valid_name) { 'a'*rand(3..20) }
  let(:unvalid_name) { 'a'*rand(0..2) }
  let(:list) { [{
    name: valid_name,
    difficulty: Game::DIFFICULTIES.keys.first.to_s,
    all_attempts: 15,
    attempts_used: 15,
    all_hints: 2,
    hints_used: 0
  }]}

  context 'when testing #game_menu method' do
    it 'works with choice_options' do
      expect(subject.renderer).to receive(:start_message)
      allow(subject).to receive(:gets).and_return('')
      expect(subject).to receive(:choice_menu_process).once
      subject.game_menu
    end
  end

  context 'when testing #rules' do
    it 'calls rules message' do
      expect(subject.renderer).to receive(:rules)
      expect(subject).to receive(:game_menu)
      subject.send(:rules)
    end
  end

  context 'when testing #new_game method' do
    it do
      expect(subject).to receive(:registration)
      expect(subject).to receive(:level_choice)
      expect(subject).to receive(:game_process)
      subject.send(:new_game)
    end
  end

  context 'when testing #stats method' do
    it 'returns stats' do
      statistics = subject.instance_variable_get(:@statistics)
      expect(statistics).to receive(:stats).with(subject.data)
      expect(subject).to receive(:render_stats)
      expect(subject).to receive(:game_menu)
      subject.send(:stats)
    end
  end

  context 'when testing #save_result method' do
    it 'expexts the choice of user' do
      allow(subject).to receive(:gets).and_return(Menu::CHOOSE_COMMANDS[:yes])
      expect(subject).to receive(:choice_save_process)
      subject.send(:save_result)
    end
  end

  context 'when testing #registration method' do
    it 'set name' do
      allow(subject).to receive(:gets).and_return(valid_name)
      subject.send(:registration)
    end
  end

  context 'when testing #name_valid? method' do
    it 'returns true' do
      subject.instance_variable_set(:@name, valid_name)
      subject.send(:name_valid?)
    end

    it 'returns false' do
      subject.instance_variable_set(:@name, unvalid_name)
      subject.send(:name_valid?)
    end
  end

  context 'when testing #level_choice method' do
    it 'checks input of user' do
      allow(subject).to receive(:gets).and_return(Game::DIFFICULTIES.keys.first.to_s)
      subject.send(:level_choice)
    end
  end

  context 'when testing #choice_code_process method' do
    it 'returns #take_a_hint!' do
      allow(subject).to receive(:gets).and_return(Menu::COMMANDS[:exit])
      expect(subject).to receive(:take_a_hint!)
      subject.send(:choice_code_process, Menu::COMMANDS[:hint])
    end

    it 'returns #game_menu' do
      allow(subject).to receive(:gets).and_return([])
      expect(subject).to receive(:game_menu)
      subject.send(:choice_code_process, Menu::COMMANDS[:exit])
    end

    it 'returns #handle_command' do
      allow(subject).to receive(:gets).and_return([])
      expect(subject).to receive(:handle_command).with(command)
      subject.send(:choice_code_process, command)
    end
  end

  context 'when testing #choice_save_process method' do
    it 'returns save_game_result' do
      allow(subject).to receive(:gets).and_return('')
      subject.instance_variable_set(:@name, valid_name)
      subject.instance_variable_set(:@level, Game::DIFFICULTIES.keys.first.to_s)
      subject.game.instance_variable_set(:@attempts, Game::DIFFICULTIES[:easy][:attempts])
      subject.game.instance_variable_set(:@hints, HINTS_ARRAY)
      expect(subject.data).to receive(:save_game_result)
      subject.send(:choice_save_process, Menu::CHOOSE_COMMANDS[:yes].to_s)
    end

    it 'returns #game_menu' do
      allow(subject).to receive(:gets).and_return('')
      expect(subject).to receive(:game_menu)
      subject.send(:choice_save_process, Menu::CHOOSE_COMMANDS[:no].to_s)
    end

    it 'calls save_result' do
      allow(subject).to receive(:gets).and_return('')
      expect(subject.renderer).to receive(:command_error)
      expect(subject).to receive(:save_result)
      subject.send(:choice_save_process, command)
    end
  end

  context 'when testing #render_stats' do
    it 'returns list' do
      subject.send(:render_stats, list)
    end
  end

  context 'when testing #choice_menu_process' do
    it 'returns #start_game' do
      allow(subject).to receive(:gets).and_return(Game::DIFFICULTIES.keys.first.to_s)
      expect(subject).to receive(:new_game)
      subject.send(:choice_menu_process, Menu::COMMANDS[:start])
    end

    it 'returns #exit_from_game' do
      allow(subject).to receive(:gets).and_return(Game::DIFFICULTIES.keys.first.to_s)
      expect(subject).to receive(:exit_from_game)
      subject.send(:choice_menu_process, Menu::COMMANDS[:exit])
    end

    it 'returns #rules' do
      allow(subject).to receive(:gets).and_return(Game::DIFFICULTIES.keys.first.to_s)
      expect(subject).to receive(:rules)
      subject.send(:choice_menu_process, Menu::COMMANDS[:rules])
    end

    it 'returns #stats' do
      allow(subject).to receive(:gets).and_return(Game::DIFFICULTIES.keys.first.to_s)
      expect(subject).to receive(:stats)
      subject.send(:choice_menu_process, Menu::COMMANDS[:stats])
    end

    it 'returns command_error' do
      allow(subject).to receive(:gets).and_return(Game::DIFFICULTIES.keys.first.to_s)
      expect(subject.renderer).to receive(:command_error)
      expect(subject).to receive(:game_menu)
      subject.send(:choice_menu_process, command)
    end
  end

  context 'when testing #exit_from_game method' do
    it 'returns message' do
      expect(subject.renderer).to receive(:goodbye_message)
      expect(subject).to receive(:exit)
      subject.send(:exit_from_game)
    end
  end

  context 'when testing #take_a_hint! method' do
    it 'returns no_hints_message?' do
      subject.game.instance_variable_set(:@hints, [])
      expect(subject.renderer).to receive(:no_hints_message?)
      subject.send(:take_a_hint!)
    end
  end
end
