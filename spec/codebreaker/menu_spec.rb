# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Menu do
  let(:statistics) { Statistics.new }

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
      allow(subject).to receive(:gets).and_return(Commands::YES)
      expect(subject).to receive(:choice_save_process).once
      subject.save_result
    end
  end

  context 'when testing #level_choice method' do
    it 'checks input of user' do
      expect(subject.renderer).to receive(:hard_level)
      allow(subject).to receive(:gets).and_return(Game::HELL)
      expect(subject).to receive(:commands_to_choose_level).once
      subject.level_choice
    end
  end

  context 'when testing #choice_save_process method' do
    it 'process the user input' do
      expect(subject).to receive(:command_save).once
      subject.choice_save_process(Commands::YES)
    end
  end

  context 'when testing #choice_menu_process method' do
    it 'process the user input' do
      expect(subject).to receive(:main_commands).once
      subject.choice_menu_process(Commands::EXIT)
    end
  end

  context 'when testing #choice_code_process method' do
    it 'process the user input' do
      game = subject.instance_variable_get(:@game)
      expect(subject).to receive(:commands_in_game)
      expect(game).to receive(:start_process)
      subject.choice_code_process(Commands::EXIT)
    end
  end

  context 'when testing #win method' do
    it 'returns nil' do
      result = ['+','+','+','-']
      expect(subject.win(result)).to be nil
      subject.win(result)
    end

    it 'returns #win_game_message' do
      result = Array.new(Game::DIGITS_COUNT, '+')
      expect(subject.win(result)).to be true
      expect(subject.renderer).to receive(:win_game_message)
      subject.win(result)
    end
  end
end
