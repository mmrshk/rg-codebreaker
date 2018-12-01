require 'spec_helper'
require 'pry'

RSpec.describe DataStorage do
  context 'when testing #storage_exist' do
    it 'checks existence of file' do
      expect(File).to exist("lib/database/data.yml")
    end
  end

=begin
  context 'when test #save' do
    it "should open file and put object in it" do
     file = mock('file')
     File.should_receive(:open).with("filename", "w").and_yield(file)
     file.should_receive(:write).with("text")
     subject.save
   end
  end
=end


end
