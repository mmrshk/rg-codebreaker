# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Menu do
  let(:hints_array) { [1, 2] }
  let(:command) { '1111' }
  let(:valid_name) { 'a' * rand(3..20) }
  let(:invalid_name) { 'a' * rand(0..2) }
  let(:list) do
    [{
      name: valid_name,
      difficulty: Game::DIFFICULTIES.keys.first.to_s,
      all_attempts: 15,
      attempts_used: 15,
      all_hints: 2,
      hints_used: 0
    }]
  end

  context 'when testing #game_menu method' do
    it 'works with choice_options' do
      expect(subject.renderer).to receive(:start_message)
      expect(subject).to receive(:ask)
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
      expect(subject).to receive(:ask).with(:save_results_message).and_return(Menu::CHOOSE_COMMANDS[:yes])
      name = subject.instance_variable_set(:@name, valid_name)
      level = subject.instance_variable_set(:@level, Game::DIFFICULTIES.keys.first.to_s)
      subject.game.instance_variable_set(:@attempts, Game::DIFFICULTIES[:easy][:attempts])
      subject.game.instance_variable_set(:@hints, hints_array)
      user_hash = subject.game.to_h(name, level)
      expect(subject.data).to receive(:save_game_result).with(user_hash)
      subject.send(:save_result)
    end
  end

  context 'when testing #registration method' do
    it 'set name' do
      expect(subject).to receive(:ask).with(:registration).and_return(valid_name)
      subject.send(:registration)
    end
  end

  context 'when testing #name_valid? method' do
    it 'returns true' do
      subject.instance_variable_set(:@name, valid_name)
      subject.send(:name_valid?)
    end

    it 'returns false' do
      subject.instance_variable_set(:@name, invalid_name)
      subject.send(:name_valid?)
    end
  end

  context 'when testing #level_choice method' do
    it 'checks input of user' do
      expect(subject).to receive(:ask).with(:hard_level, levels: Game::DIFFICULTIES.keys.join(' | ')).and_return(Game::DIFFICULTIES.keys.first.to_s)
      expect(subject).to receive(:choose_level)
      subject.send(:level_choice)
    end
  end

  context 'when testing #choice_code_process method' do
    it 'returns #take_a_hint!' do
      expect(subject).to receive(:hint_process!)
      subject.send(:choice_code_process, Menu::COMMANDS[:hint])
    end

    it 'returns #game_menu' do
      expect(subject).to receive(:game_menu)
      subject.send(:choice_code_process, Menu::COMMANDS[:exit])
    end

    it 'returns #handle_command' do
      expect(subject).to receive(:handle_command).with(command)
      subject.send(:choice_code_process, command)
    end
  end

  context 'when testing #render_stats' do
    it 'returns list' do
      expect(list).to receive(:each_with_index)
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

  context 'when testing #hint_process! method' do
    it 'returns no_hints_message?' do
      subject.game.instance_variable_set(:@hints, [])
      expect(subject.renderer).to receive(:no_hints_message?)
      subject.send(:hint_process!)
    end
  end

  context 'when testing #generate_game method' do
    it do
      difficulty = Game::DIFFICULTIES.keys.first.to_s
      expect(subject.game).to receive(:generate).with(Game::DIFFICULTIES[difficulty])
      expect(subject.renderer).to receive(:message).with(difficulty)
      subject.send(:generate_game, difficulty)
    end
  end

  context 'when testing #choose_level method' do
    it 'returns generated game' do
      level = Game::DIFFICULTIES.keys.first.to_s
      expect(subject).to receive(:generate_game).with(level.to_sym)
      subject.send(:choose_level, level)
    end

    it 'returns #game_menu' do
      expect(subject).to receive(:game_menu)
      subject.send(:choose_level, Menu::COMMANDS[:exit])
    end

    it 'retuns #level_choice' do
      expect(subject.renderer).to receive(:command_error)
      expect(subject).to receive(:level_choice)
      subject.send(:choose_level, command)
    end
  end

  context 'when testing #handle_lose method' do
    it do
      expect(subject.renderer).to receive(:lost_game_message).with(subject.game.code)
      expect(subject).to receive(:game_menu)
      subject.send(:handle_lose)
    end
  end

  context 'when testing #handle_win method' do
    it do
      expect(subject.renderer).to receive(:win_game_message)
      expect(subject).to receive(:save_result)
      expect(subject).to receive(:game_menu)
      subject.send(:handle_win)
    end
  end

  context 'when testing #game_process method' do
    it 'retuns #handle_win' do
      subject.game.instance_variable_set(:@attempts, Game::DIFFICULTIES[:easy][:attempts])
      expect(subject).to receive(:player_wins?) { true }
      expect(subject).to receive(:handle_win)
      subject.send(:game_process)
    end

    it 'retuns #handle_lose' do
      subject.game.instance_variable_set(:@attempts, 0)
      expect(subject).to receive(:handle_lose)
      subject.send(:game_process)
    end
  end

  context 'when testing #ask method' do
    it 'retuns msg' do
      phrase_key = :rules
      expect(subject.renderer).to receive(:message).with(phrase_key, {})
      allow(subject).to receive(:gets).and_return('')
      subject.send(:ask, phrase_key)
    end
  end
end
