# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Processor do
  CODE_P = '1223'
  QUESS = '1223'
  CODE_ARRAY = [1, 2, 3, 4]

  context 'when testing #turn_process method' do
    it 'returns result_array' do
      expect(subject).to receive(:place_match)
      expect(subject).to receive(:out_of_place_match)
      subject.turn_process(CODE_P, QUESS)
    end
  end

  context 'when testing #place_match method' do
    [
      [
        [1, 1, 1, 1], ['+', ' ', ' ', ' ']
      ],
      [
        [2, 2, 2, 2], [' ', '+', ' ', ' ']
      ],
      [
        [3, 3, 3, 3], [' ', ' ', '+', ' ']
      ],
      [
        [4, 4, 4, 4], [' ', ' ', ' ', '+']
      ],
      [
        [1, 2, 1, 1], ['+', '+', ' ', ' ']
      ],
      [
        [1, 1, 3, 1], ['+', ' ', '+', ' ']
      ],
      [
        [1, 2, 3, 1], ['+', '+', '+', ' ']
      ],
      [
        [5, 6, 5, 6], [' ', ' ', ' ', ' ']
      ]
    ].each do |value|
      it "tests that #{value.first} equals to #{value.last}" do
        expect(subject.place_match(CODE_ARRAY, value.first)).to eq value.last
      end
    end
  end

  context 'when testing #hint_processor method' do
    it 'checks if hint is displayed' do
      subject.hint_process(CODE_ARRAY)
    end
  end

  context 'when testing #out_of_place_match method' do
    code = [1, 2, 3, 4]
    [
      [
        [1, 1, 1, 1], ['+', ' ', ' ', ' ']
      ],
      [
        [2, 2, 2, 2], [' ', '+', ' ', ' ']
      ],
      [
        [3, 3, 3, 3], [' ', ' ', '+', ' ']
      ],
      [
        [4, 4, 4, 4], [' ', ' ', ' ', '+']
      ],
      [
        [1, 2, 1, 1], ['+', '+', ' ', ' ']
      ],
      [
        [1, 1, 3, 1], ['+', ' ', '+', ' ']
      ],
      [
        [5, 6, 5, 6], [' ', ' ', ' ', ' ']
      ]
    ].each do |value|
      it "returns '-' or ' ' as is guess: #{value[0]}, incomming result: #{value[1]}, result array: #{value.last}" do
        expect(subject.out_of_place_match(value.last, code, value.first)).to eq value.last
      end
    end
    [
      [
        [1, 1, 5, 6], ['+', ' ', ' ', ' '], ['+', '-', ' ', ' ']
      ],
      [
        [1, 3, 5, 3], ['+', ' ', ' ', ' '], ['+', '-', ' ', '-']
      ],
      [
        [1, 4, 2, 3], ['+', ' ', ' ', ' '], ['+', '-', '-', '-']
      ],
      [
        [1, 1, 3, 6], ['+', ' ', '+', ' '], ['+', '-', '+', ' ']
      ],
      [
        [1, 1, 2, 4], ['+', ' ', ' ', '+'], ['+', '-', '-', '+']
      ]
    ].each do |value|
      it "tests that #{value.first} equals to #{value.last}" do
        expect(subject.out_of_place_match(value[1], code, value[0])).to eq value.last
      end
    end
  end
end
