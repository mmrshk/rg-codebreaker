# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DataStorage do
  before do
    stub_const('DataStorage::FILE_NAME', 'database/data_test.yml')
  end
  let(:test_object) do
    {
      name: '',
      difficulty: Game::DIFFICULTIES.keys.first,
      all_attempts: 15,
      attempts_used: 15,
      all_hints: 2,
      hints_used: 0
    }
  end

  context 'when testing #storage_exist?' do
    it 'checks existence of file' do
      subject.create
      expect(File).to exist(DataStorage::FILE_NAME)
      subject.storage_exist?
    end
  end

  context 'when testing #save' do
    it 'works fine only if instance of Game passed' do
      subject.save(test_object)
    end
  end

  context 'when testing #create' do
    it 'creates new file' do
      subject.create
    end
  end

  context 'when testing #load' do
    it 'load database' do
      subject.create
      subject.save(test_object)
      expect(subject.load).to eq test_object
    end
  end

  context 'when testing #save_game_result' do
    it 'saves result' do
      subject.create
      expect(subject).to receive(:save).with([].push(test_object))
      subject.save_game_result(test_object)
    end
  end
end
