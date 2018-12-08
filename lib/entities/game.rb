# frozen_string_literal: true

class Game
  WIN_ARRAY_LENGTH = 4
  DIFFICULTIES = {
    easy: {
      attempts: 15,
      hints: 2,
      msg_name: :easy_game
    },
    medium: {
      attempts: 10,
      hints: 1,
      msg_name: :medium_game
    },
    hell: {
      attempts: 5,
      hints: 1,
      msg_name: :hell_game
    }
  }.freeze
  EASY = 'easy'
  MEDIUM = 'medium'
  HELL = 'hell'

  attr_reader :attempts, :hints

  def initialize
    @process = Processor.new
    @data = DataStorage.new
    @renderer = Renderer.new
  end

  def generate
    Array.new(WIN_ARRAY_LENGTH) { rand(1..6) }
  end

  def generate_game(hints:, attempts:, msg_name:)
    @code = generate
    @hints = @code.sample(hints)
    @attempts = attempts
    @renderer.message(msg_name)
  end

  def check_for_lose
    return unless @attempts.zero?

    @renderer.lost_game_message(@code)
    false
  end

  def attempts_left
    @attempts -= 1
  end

  def lost_hints
    return @renderer.no_hints_message? if @hints.empty?

    @renderer.digit_on_place(@process.hint_process(@hints))
  end

  def start_process(command)
    @process.turn_process(@code, command)
  end

  def calculate(param, difficulty)
    initial_params = Game::DIFFICULTIES[difficulty.to_sym]

    calculated = { tries: initial_params[:attempts] - @attempts,
                   suggestions: initial_params[:hints] - @hints.length }
    calculated[param]
  end
end
