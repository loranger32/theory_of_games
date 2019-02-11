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

  def pay_traitor
    winner, loser = players.partition { |player| player.betrays? }
    winner.earn_max
    loser.earn_min
  end

  private

  attr_reader :players

end
