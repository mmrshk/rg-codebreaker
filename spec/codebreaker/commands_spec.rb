# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Commands do
  let(:menu) { Menu.new }
  let(:game) { Game.new }

  context 'when testing #main_commands' do
    it 'returns #start_game' do
      allow(menu).to receive(:gets).and_return(Game::HELL)
      expect(menu).to receive(:new_game)
      menu.main_commands(Commands::START)
    end

    it 'returns #exit_from_game' do
      allow(menu).to receive(:gets).and_return(Game::HELL)
      expect(menu).to receive(:exit_from_game)
      menu.main_commands(Commands::EXIT)
    end

    it 'returns #rules' do
      allow(menu).to receive(:gets).and_return(Game::HELL)
      expect(menu).to receive(:rules)
      menu.main_commands(Commands::RULES)
    end

    it 'returns #stats' do
      allow(menu).to receive(:gets).and_return(Game::HELL)
      expect(menu).to receive(:stats)
      menu.main_commands(Commands::STATS)
    end

    it 'returns command_error' do
      allow(menu).to receive(:gets).and_return(Game::HELL)
      expect(menu.renderer).to receive(:command_error)
      expect(menu).to receive(:game_menu)
      menu.main_commands(Commands::STATS + "w")
    end
  end

  context 'when testing #commands_to_choose_level' do
    it 'generates easy game' do
      allow(game).to receive(:gets).and_return(Game::EASY)
      expect(game).to receive(:generate_game).with(Game::DIFFICULTIES[Game::EASY.to_sym])
      menu.commands_to_choose_level(Game::EASY, game)
    end

    it 'generates medium game' do
      allow(game).to receive(:gets).and_return(Game::MEDIUM)
      expect(game).to receive(:generate_game).with(Game::DIFFICULTIES[Game::MEDIUM.to_sym])
      menu.commands_to_choose_level(Game::MEDIUM, game)
    end

    it 'generates hell game' do
      allow(game).to receive(:gets).and_return(Game::HELL)
      expect(game).to receive(:generate_game).with(Game::DIFFICULTIES[Game::HELL.to_sym])
      menu.commands_to_choose_level(Game::HELL, game)
    end

    it 'returns #game_menu' do
      allow(menu).to receive(:gets).and_return(Commands::EXIT)
      expect(menu).to receive(:exit_from_game)
      menu.main_commands(Commands::EXIT)
    end

    it 'generates easy_game' do
      allow(menu).to receive(:gets).and_return(Game::HELL)
      expect(menu).to receive(:check_level)
      menu.commands_to_choose_level(Commands::STATS + "w", game)
    end
  end

  context 'when testing #commands_in_game method' do
    it 'returns #lost_hints' do
      allow(game).to receive(:gets).and_return(Commands::EXIT)
      expect(game).to receive(:lost_hints)
      menu.commands_in_game(Commands::HINT, game)
    end

    it 'returns #check_command' do
      allow(menu).to receive(:gets).and_return([])
      expect(menu).to receive(:check_command)
      menu.commands_in_game(Commands::STATS + "w", game)
    end
  end

  context 'when testing #command_save method' do
    it 'returns save_game_result' do
      allow(menu).to receive(:gets).and_return(Commands::EXIT)
      expect(menu).to receive(:save_game_result)
      menu.command_save(Commands::YES)
    end

    it 'returns check_save' do
      expect(menu).to receive(:check_save)
      menu.command_save(Commands::EXIT + 'w')
    end
  end
end
