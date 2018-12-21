# frozen_string_literal: true

class Game
  DIGITS_COUNT = 4
  DIFFICULTIES = {
    easy: {
      attempts: 15,
      hints: 2
    },
    medium: {
      attempts: 10,
      hints: 1
    },
    hell: {
      attempts: 5,
      hints: 1
    }
  }.freeze
  RANGE = (1..6).freeze
  HINT = 'hint'

  attr_reader :attempts, :hints, :code

  def initialize
    @process = Processor.new
  end

  def generate(difficulty)
    @level = difficulty
    @code = generate_secret_code
    @hints = @code.sample(DIFFICULTIES[difficulty][:hints])
    @attempts = DIFFICULTIES[difficulty][:attempts]
  end

  def start_process(command)
    @process.secret_code_proc(code.join, command)
  end

  def win?(result)
    code.join == result
  end

  def decrease_attempts!
    @attempts -= 1
  end

  def to_h(name)
    {
      name: name,
      difficulty: @level.to_s,
      all_attempts: DIFFICULTIES[@level][:attempts],
      all_hints: DIFFICULTIES[@level][:hints],
      **calculate
    }
  end

  def calculate
    initial_params = DIFFICULTIES[@level]
    {
      attempts_used: initial_params[:attempts] - @attempts,
      hints_used: initial_params[:hints] - @hints.length
    }
  end

  def hints_spent?
    hints.empty?
  end

  def take_a_hint!
    hints.pop
  end

  private

  def generate_secret_code
    Array.new(DIGITS_COUNT) { rand(RANGE) }
  end
end
