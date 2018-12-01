# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DataStorage do
  context 'when testing #storage_exist' do
    it 'checks existence of file' do
      expect(File).to exist('lib/database/data.yml')
    end
  end
end
