# frozen_string_literal: true

class Statistics
  def stats(data)
    list = data.load
    hell = difficulty(list, Game::HELL.to_s)
    medium = difficulty(list, Game::MEDIUM.to_s)
    easy = difficulty(list, Game::EASY.to_s)
    list = hell + medium + easy
    render_stats(list)
  end

  private
  
  def difficulty(list, difficulty)
    stats_sort(select_difficulty(list, difficulty))
  end

  def select_difficulty(list, difficulty)
    difficulty_array = []
    list.select { |key, _| difficulty_array.push(key) if key[:difficulty] == difficulty }
    difficulty_array
  end

  def stats_sort(players_array)
    players_array.sort_by! { |k| [k[:attempts_used], k[:hints_used]] }.reverse
  end

  def render_stats(list)
    list.each_with_index do |key, index|
      puts "#{index + 1}: "
      key.each { |el, value| puts "#{el}:#{value}" }
    end
  end
end
