# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Commands do
  context 'when testing #main_commands' do
    it 'returns #start_game' do
      menu = Menu.new
      command_name = 'start'
      allow(menu).to receive(:gets).and_return('hell')
      expect(menu).to receive(:start_game)
      menu.main_commands(command_name)
    end

    it 'returns #exit_from_game' do
      menu = Menu.new
      command_name = 'exit'
      allow(menu).to receive(:gets).and_return('hell')
      expect(menu).to receive(:exit_from_game)
      menu.main_commands(command_name)
    end

    it 'returns #rules' do
      menu = Menu.new
      command_name = 'rules'
      allow(menu).to receive(:gets).and_return('hell')
      expect(menu).to receive(:rules)
      menu.main_commands(command_name)
    end

    it 'returns #stats' do
      menu = Menu.new
      command_name = 'stats'
      allow(menu).to receive(:gets).and_return('hell')
      expect(menu).to receive(:stats)
      menu.main_commands(command_name)
    end

    it 'returns command_error' do
      menu = Menu.new
      command_name = 'statsdasdas'
      allow(menu).to receive(:gets).and_return('hell')
      expect(I18n).to receive(:t).with(:command_error, {})
      expect(menu).to receive(:game_menu)
      menu.main_commands(command_name)
    end
  end

  context 'when testing #message' do
    it 'returns message' do
      menu = Menu.new
      msg_name = :registration
      expect(I18n).to receive(:t).with(msg_name, {})
      menu.message(msg_name)
    end
  end

  context 'when testing #command_save method' do
    it 'returns save_game_result' do
      menu = Menu.new
      command_name = 'yes'
      allow(menu).to receive(:gets).and_return('exit')
      expect(menu).to receive(:save_game_result)
      menu.command_save(command_name)
    end

    it 'returns #game_menu' do
      menu = Menu.new
      command_name = 'jhkjh'
      allow(menu).to receive(:gets).and_return('exit')
      expect(menu).to receive(:check_save)
      menu.command_save(command_name)
    end
  end

  context 'when testing #commands_in_game method' do
    it 'returns save_game_result' do
      menu = Menu.new
      command_name = 'hint'
      allow(menu).to receive(:gets).and_return('exit')
      expect(menu).to receive(:lost_hints)
      menu.commands_in_game(command_name)
    end

    it 'returns #game_menu' do
      menu = Menu.new
      command_name = 'jhkjh'
      allow(menu).to receive(:gets).and_return('exit')
      expect(menu).to receive(:check_command)
      menu.commands_in_game(command_name)
    end
  end

  context 'when testing #commands' do
    it 'generates easy_game' do
      menu = Menu.new
      command_name = 'easy'
      allow(menu).to receive(:gets).and_return('hell')
      expect(menu).to receive(:generate_game)
      menu.commands(command_name)
    end

    it 'generates easy_game' do
      menu = Menu.new
      command_name = 'medium'
      allow(menu).to receive(:gets).and_return('hell')
      expect(menu).to receive(:generate_game)
      menu.commands(command_name)
    end

    it 'generates easy_game' do
      menu = Menu.new
      command_name = 'hell'
      allow(menu).to receive(:gets).and_return('hell')
      expect(menu).to receive(:generate_game)
      menu.commands(command_name)
    end

    it 'generates easy_game' do
      menu = Menu.new
      command_name = 'heasdsdll'
      allow(menu).to receive(:gets).and_return('hell')
      expect(menu).to receive(:check_level)
      menu.commands(command_name)
    end
  end
end
