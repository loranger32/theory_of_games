class EarningEngine

  attr_reader :players
  
  def initialize
    @players = nil
  end

  def assign_players(players)
    @players = players
  end

  def give_each_player_medium_earning
    players.map(&:earn_medium)
  end

  def give_each_player_minimum_earning
    players.map(&:earn_min)
  end

  def give_min_earning_to(naive)
    naive.earn_min
  end

  def give_max_earning_to(traitor)
    traitor.earn_max
  end
end
