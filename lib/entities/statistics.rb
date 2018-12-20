# frozen_string_literal: true

class Statistics
  def stats(list)
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
    list.select { |key, _| key[:all_attempts] == difficulty[:attempts] }
  end

  def stats_sort(players_array)
    players_array.sort_by! { |k| [k[:attempts_used], k[:hints_used]] }.reverse
  end
end
