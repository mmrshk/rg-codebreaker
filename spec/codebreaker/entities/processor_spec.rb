# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Codebreaker::Entities::Processor do
  context 'when testing #secret_code_proc method' do
    [
      ['1234', '1234', '++++'], ['1234', '4321', '----'], ['1231', '1234', '+++'],
      ['1324', '1234', '++--'], ['1111', '1321', '++'], ['4441', '2233', ''],
      ['1234', '1111', '+'], ['2552', '1221', '--'], ['1234', '2332', '+-'],
      ['1234', '5561', '-'], ['1234', '1342', '+---'], ['3211', '1561', '+-'],
      ['1134', '1155', '++'], ['1134', '5115', '+-'], ['1134', '5511', '--'],
      ['1134', '1115', '++'], ['1134', '5111', '+-'], ['1234', '1555', '+'],
      ['1234', '2555', '-'], ['1234', '5224', '++'], ['1234', '5154', '+-'],
      ['1234', '2545', '--'], ['1234', '5234', '+++'], ['1234', '5134', '++-'],
      ['1234', '5124', '+--'], ['1234', '5115', '-'], ['1666', '6661', '++--'],
      ['1234', '1234', '++++'], ['5143', '4153', '++--'], ['5523', '5155', '+-'],
      ['6235', '2365', '+---'], ['1234', '4321', '----'], ['1234', '1235', '+++'],
      ['1234', '6254', '++'], ['1234', '5635', '+'], ['1234', '4326', '---'],
      ['1234', '3525', '--'], ['1234', '2552', '-'], ['1234', '4255', '+-'],
      ['1234', '1524', '++-'], ['1234', '5431', '+--'], ['1234', '6666', ''],
      ['1115', '1231', '+-'], ['1231', '1111', '++'],
      ['1111', '1111', '++++'], ['1111', '1115', '+++'], ['1111', '1155', '++'],
      ['1111', '1555', '+'], ['1111', '5555', ''], ['1221', '2112', '----'],
      ['1221', '2114', '---'], ['1221', '2155', '--'], ['1221', '2555', '-'],
      ['2245', '2254', '++--'], ['2245', '2253', '++-'], ['2245', '2435', '++-'],
      ['2245', '2533', '+-'], ['1234', '4321', '----'], ['3331', '3332', '+++'],
      ['1113', '1112', '+++'], ['1312', '1212', '+++'], ['1234', '1266', '++'],
      ['1234', '6634', '++'], ['1234', '1654', '++'], ['1234', '1555', '+'],
      ['1234', '4321', '----'], ['5432', '2345', '----'], ['1234', '2143', '----'],
      ['1221', '2112', '----'], ['5432', '2541', '---'], ['1145', '6514', '---'],
      ['1244', '4156', '--'], ['1221', '2332', '--'], ['2244', '4526', '--'],
      ['5556', '1115', '-'], ['1234', '6653', '-'], ['3331', '1253', '--'],
      ['2345', '4542', '+--'], ['1243', '1234', '++--'], ['4111', '4444', '+'],
      ['1532', '5132', '++--'], ['3444', '4334', '+--'], ['1113', '2155', '+'],
      ['2245', '4125', '+--'], ['4611', '1466', '---'], ['5451', '4445', '+-'],
      ['6541', '6541', '++++'], ['1234', '5612', '--'], ['5566', '5600', '+-'],
      ['6235', '2365', '+---'], ['1234', '4321', '----'], ['1234', '1235', '+++'],
      ['1234', '6254', '++'], ['1234', '5635', '+'], ['1234', '4326', '---'],
      ['1234', '3525', '--'], ['1234', '2552', '-'], ['1234', '4255', '+-'],
      ['1234', '1524', '++-'], ['1234', '5431', '+--'], ['1234', '6666', ''],
      ['1115', '1231', '+-'], ['1221', '2112', '----'], ['1231', '1111', '++']
    ].each do |value|
      it "tests that #{value.first} equals to #{value.last}" do
        expect(subject.secret_code_proc(value[1], value[0])).to eq value.last
      end
    end
  end
end
