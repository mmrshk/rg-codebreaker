# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DataStorage do
  before do
    stub_const('DataStorage::FILE_NAME', 'database/data_test.yml')
  end
  TEST_OBJECT = {
    name: '',
    difficulty: Game::EASY,
    all_attempts: 15,
    attempts_used: 15,
    all_hints: 2,
    hints_used: 0
  }.freeze

  context 'when testing #storage_exist?' do
    it 'checks existence of file' do
      expect(File).to exist(DataStorage::FILE_NAME)
      subject.storage_exist?
    end
  end

  context 'when testing #save' do
    it 'works fine only if instance of Game passed' do
      subject.save(TEST_OBJECT)
    end
  end

  context 'when testing #load' do
    it 'load database' do
      subject.load
    end
  end

  context 'when testing #create' do
    it 'creates new file' do
      subject.create
    end
  end
end
