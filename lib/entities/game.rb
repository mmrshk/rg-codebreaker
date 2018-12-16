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
  WIN_RESULT = '++++'

  attr_reader :attempts, :hints, :code

  def initialize
    @process = Processor.new
  end

  def generate(hints:, attempts:)
    @code = generate_secret_code
    @hints = @code.sample(hints)
    @attempts = attempts
  end

  def start_process(command)
    @process.secret_code_proc(code.join, command)
  end

  def decrease_attempts!
    @attempts -= 1
  end

  def to_h(name, level)
    {
      name: name,
      difficulty: level,
      all_attempts: DIFFICULTIES[level.to_sym][:attempts],
      attempts_used: calculate(:tries, level),
      all_hints: DIFFICULTIES[level.to_sym][:hints],
      hints_used: calculate(:suggestions, level)
    }
  end

  def calculate(param, difficulty)
    initial_params = Game::DIFFICULTIES[difficulty.to_sym]

    calculated = { tries: initial_params[:attempts] - @attempts,
                   suggestions: initial_params[:hints] - @hints.length }
    calculated[param]
  end

  def hints_spent?
    hints.empty?
  end

  def take_a_hint!
    hints.pop
  end

  def win?(result)
    result == WIN_RESULT
  end

  private

  def generate_secret_code
    Array.new(DIGITS_COUNT) { rand(RANGE) }
  end
end
