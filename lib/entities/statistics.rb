# frozen_string_literal: true

class Statistics
  def stats(data)
    list = data.load
    easy = difficulty(list, Game::DIFFICULTIES.keys[0].to_s)
    medium = difficulty(list, Game::DIFFICULTIES.keys[1].to_s)
    hell = difficulty(list, Game::DIFFICULTIES.keys[2].to_s)
    hell + medium + easy
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
end
