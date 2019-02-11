class TwoPlayerLogic
  def initialize(players, earning_engine)
    @players = players
    @earning_engine = earning_engine
  end

  def process_moves 
    if all_players_cooperate?
      earning_engine.give_each_player_medium_earning
    elsif all_players_betray
      earning_engine.give_each_player_minimum_earning
    elsif one_traitor_and_one_naive
      earning_engine.pay_traitor  
    else
      err_msg = "Something went wrong : invalid moves combinaison - unable to\
 to define earnings."
      raise StandardError, err_msg
    end
  end

  def all_players_cooperate?
    players.all(&:cooperates?)
  end

  def all_players_betray
    players.all(&:betrays?)
  end

  def one_traitor_and_one_naive
    players.any?(&:cooperates) && players.any(&:betrays?)
  end

  private

  attr_reader :players, :earning_engine
end


