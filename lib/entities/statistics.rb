# frozen_string_literal: true

class Statistics
  def stats(list)
    hash = list.group_by { |score| score[:difficulty] }
    %w[hell medium easy].reduce([]) do |previous, current|
      hash[current] ? previous + stats_sort(hash[current]) : previous
    end
  end

  private

  def stats_sort(players_array)
    players_array.sort_by! { |k| [k[:attempts_used], k[:hints_used]] }.reverse
  end
end
