# Class holding the rules of the game
class TwoPlayerLogic
  def initialize(earning_engine)
    @players = nil
    @earning_engine = earning_engine
  end

  def assign_players(players)
    @players = players
    @earning_engine.assign_players(players)
  end

  def process_moves
    if all_players_cooperate?
      earning_engine.give_each_player_medium_earning
    elsif all_players_betray?
      earning_engine.give_each_player_minimum_earning
    elsif one_traitor_and_one_naive?
      pay_max_to_traitor_and_min_to_naive
    else
      raise StandardError, "Something went wrong : invalid moves combinaison -\
 unable to define earnings."
    end
  end

  private

  def all_players_cooperate?
    players.all?(&:cooperates?)
  end

  def all_players_betray?
    players.all?(&:betrays?)
  end

  def one_traitor_and_one_naive?
    players.any?(&:cooperates?) && players.any?(&:betrays?)
  end

  def pay_max_to_traitor_and_min_to_naive
    traitor, naive = retrieve_winner_and_loser
    earning_engine.give_min_earning_to(naive)
    earning_engine.give_max_earning_to(traitor)
  end

  def retrieve_winner_and_loser
    winner = players.find(&:betrays?)
    loser = players.find(&:cooperates?)
    [winner, loser]
  end

  attr_reader :players, :earning_engine
end
