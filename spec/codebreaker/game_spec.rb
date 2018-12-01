require 'spec_helper'
require 'pry'

RSpec.describe Game do
  context 'testing #generate method' do
    it 'checks that number mathes regex template' do
      expect(subject.generate.join).to match(/^[1-6]{4}$/)
    end

    it 'returns array of integers' do
      array = subject.generate
      int_array = array.select {|x| x.is_a? Integer}
      expect(array).to eq int_array
    end
  end

  context 'used #attempts_left method' do
    it 'increases attempts by one when used' do
      subject.instance_variable_set(:@attempts_used, 3)
      expect(subject.attempts_left).to eq 4
    end
  end

  context 'when #registration method' do
    it 'gets name of user' do
      expect(I18n).to receive(:t).with(:registration)
      allow(subject).to receive(:gets).and_return('Nika')
      expect(subject).to receive(:check_name).once
      subject.registration
    end
  end

  context 'when used lost_hints method' do
    it 'returns have_no_hints_message when hints_available false' do
      subject.instance_variable_set(:@hint_avaliable, false)
      expect(I18n).to receive(:t).with(:have_no_hints_message)
      subject.lost_hints
    end

    it 'returns hint_avaliable false if hints_used eq to hints' do
      subject.instance_variable_set(:@hint_avaliable, true)
      subject.instance_variable_set(:@hints_used, 1)
      subject.instance_variable_set(:@hints, 2)
      subject.instance_variable_set(:@code, [2,1,3,1])
      expect(subject.lost_hints).to be false
    end
  end

  context 'when #lost_attempts method' do
    it 'returns lost_game_message when attempts eq to attempts_used' do
      subject.instance_variable_set(:@attempts, 2)
      subject.instance_variable_set(:@attempts_used, 2)
      expect(I18n).to receive(:t).with(:lost_game_message)
      subject.instance_variable_set(:@game_end, true)
      subject.lost_attempts
    end
  end

  context 'when testing #new_game method' do
    it 'creates new game' do
      expect(subject).to receive(:registration).once
      expect(subject).to receive(:level_choice).once
      expect(subject).to receive(:secret_code).once
      subject.new_game
    end
  end

  context 'when testing #save_result method' do
    it 'expexts the choice of user' do
      expect(I18n).to receive(:t).with(:save_results_message)
      allow(subject).to receive(:gets).and_return('yes')
      expect(subject).to receive(:choice_save_process).once
      subject.save_result
    end
  end

  context 'when testing #level_choice method' do
    it 'checks input of user' do
      expect(I18n).to receive(:t).with(:hard_level)
      allow(subject).to receive(:gets).and_return('hell')
      expect(subject).to receive(:check_level).once
      subject.level_choice
    end
  end

  context 'when #generate_game method' do
    it 'returns message' do
      hints = 1
      attempts = 10
      msg_name = :easy_game
      expect(I18n).to receive(:t).with(:easy_game)
      subject.generate_game(hints: hints, attempts: attempts, msg_name: msg_name)
    end
  end

  context 'when #save_game_result method' do
    it 'saves game result' do
      allow(subject).to receive(:gets).and_return('hell')
      expect(subject.instance_variable_get(:@data)).to receive(:load).and_return([])
      object = {
        name: 'eee',
        difficulty: 'hell',
        attempts_total: 5,
        attempts_used: 1,
        hints_total: 1,
        hints_used: 0
      }
      #expect(subject).to receive(:save).once
      subject.save_game_result
    end
  end

  context 'when testing #win method' do
    it 'returns win_game_message' do
      win_array = Array.new(4, '+')
      result =  Array.new(4, '+')
      expect(I18n).to receive(:t).with(:win_game_message)
      subject.instance_variable_set(:@game_end, true)
      subject.win(result)
    end
  end

  context 'when testing #choice_save_process method' do
    it 'process the user input' do
      choice = "yes"
      allow(subject).to receive(:gets).and_return('hell')
      expect(subject).to receive(:check_save).once
      subject.choice_save_process(choice)
    end
  end


=begin
context 'when testing #choice_process method' do
  it 'process the user input' do
    allow(subject).to receive(:gets).and_return('exit')
    command = "exit"
    expect(subject).to receive(:check_command).once
    expect(subject.instance_variable_get(:@process)).to receive(:turn_process).and_return([])
    subject.choice_process(command)
  end
end

context 'when #secret_code method' do
  it 'works with input' do
    expect(subject).to receive(:loop).and_yield
    allow(subject).to receive(:gets).and_return('1111')
    expect(subject).to receive(:choice_process)
    expect(subject).to receive(:win)
    expect(subject).to receive(:attempts_left)
    expect(subject).to receive(:lost_attempts)
    expect(subject).to receive(:save_result)
    subject.secret_code
  end
end


context 'when #generate_game' do

end
=end
end
