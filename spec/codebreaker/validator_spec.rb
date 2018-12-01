require 'spec_helper'
require 'pry'

RSpec.describe Validator do
=begin
  context 'testing #check_level method' do
    it 'returns message command_error' do
      level = "hell"
      expect(I18n).to receive(:t).with(:command_error)
      expect(subject).to receive(:level_choice).once
      subject.check_level(level)
    end
  end
=end
end
