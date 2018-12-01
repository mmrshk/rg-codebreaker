require 'spec_helper'
require 'pry'

RSpec.describe Commands do
  context 'when testing #main_commands' do
    it 'returns hash' do
      #binding.pry
      subject.main_commands
    end
  end
=begin
  context 'when testing #message' do
    it 'returns message' do
      msg_name = :registration
      expect(I18n).to receive(:t).with(msg_name)
      subject.message(msg_name)
    end
  end
=end
end
