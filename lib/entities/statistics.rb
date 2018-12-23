# frozen_string_literal: true

class Statistics
  def stats(list)
    difficulties = list.group_by { |score| score[:difficulty] }
    %w[hell medium easy].reduce([]) do |sorted_difficulties, difficulty_name|
      difficulties[difficulty_name] ? sorted_difficulties + stats_sort(difficulties[difficulty_name]) : sorted_difficulties
    end
  end

  private

  def stats_sort(scores)
    scores.sort_by! { |score| [score[:attempts_used], score[:hints_used]] }.reverse
  end
end
