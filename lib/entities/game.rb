class Game
  include Interface

  def initialize
    @process = Process.new
    @manager = DataManager.new
  end

  def generate
    Array.new(4) { rand(1..6) }
  end

  def generate_easy_game
    @code = generate
    @hints = 2
    @attempts = 15
  end

  def generate_medium_game
    @code = generate
    @hints = 1
    @attempts = 10
  end

  def generate_hell_game
    @code = generate
    @hints = 1
    @attempts = 5
  end

  def start
    start_message
    choice = gets.chomp
    #continue
  end

end
