# frozen_string_literal: true

class Statistics
  def stats(data)
    list = data.load
    easy = difficulty(list, Game::DIFFICULTIES[:easy])
    medium = difficulty(list, Game::DIFFICULTIES[:medium])
    hell = difficulty(list, Game::DIFFICULTIES[:hell])
    hell + medium + easy
  end

  private

  def difficulty(list, difficulty)
    stats_sort(select_difficulty(list, difficulty))
  end

  def select_difficulty(list, difficulty)
    difficulty_array = []
    list.select { |key, _| difficulty_array.push(key) if key[:all_attempts] == difficulty[:attempts] }
    difficulty_array
  end

  def stats_sort(players_array)
    players_array.sort_by! { |k| [k[:attempts_used], k[:hints_used]] }.reverse
  end
end
