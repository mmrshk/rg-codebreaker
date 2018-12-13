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
  EASY = :easy
  MEDIUM = :medium
  HELL = :hell

  attr_reader :attempts, :hints, :code

  def initialize
    @process = Processor.new
  end

  def generate_game(hints:, attempts:)
    @code = generate_secret_code
    @hints = @code.sample(hints)
    @attempts = attempts
  end

  def start_process(command)
    @process.secret_code_proc(@code.join, command)
  end

  def decrease_attempts
    @attempts -= 1
  end

  def calculate(param, difficulty)
    initial_params = Game::DIFFICULTIES[difficulty.to_sym]

    calculated = { tries: initial_params[:attempts] - @attempts,
                   suggestions: initial_params[:hints] - @hints.length }
    calculated[param]
  end

  private

  def generate_secret_code
    Array.new(DIGITS_COUNT) { rand(1..6) }
  end
end
