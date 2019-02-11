class EarningEngine
  def initialize(players)
    @players = players
  end

  def give_each_player_medium_earning
    players.map(&:earn_medium)
  end

  def give_each_player_minimum_earning
    players.map(&:earn_min)
  end

  def pay_min_earning_to(naive)
    naive.earn_min
  end

  def pay_max_earning_to(traitor)
    traitor.earn_max
  end

  private

  attr_reader :players

end
