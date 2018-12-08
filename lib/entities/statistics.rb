# frozen_string_literal: true

class Statistics
  def stats(menu_object)
    list = menu_object.data.load
    hell = difficulty(list, Game::HELL)
    medium = difficulty(list, Game::MEDIUM)
    easy = difficulty(list, Game::EASY)
    list = hell + medium + easy
    list.each_with_index { |key, index| puts "#{index + 1}: #{key}" }
    menu_object.game_menu
  end

  def stats_sort(players_array)
    players_array.sort_by! { |k| [k[:attempts_used], k[:hints_used]] }.reverse
  end

  def select_difficulty(list, difficulty)
    difficulty_array = []
    list.select { |key, _| difficulty_array.push(key) if key[:difficulty] == difficulty }
    difficulty_array
  end

  def difficulty(list, difficulty)
    stats_sort(select_difficulty(list, difficulty))
  end
end
