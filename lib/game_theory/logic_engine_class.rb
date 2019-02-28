# Class holding the rules of the game
class LogicEngine

  attr_reader :players, :earning_engine

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
    elsif traitors_and_naives?
      pay_max_to_traitors_and_min_to_naives
    else
      raise StandardError, "Something went wrong : invalid moves combinaison -\
 unable to define earnings."
    end
  end

  def all_players_cooperate?
    players.all?(&:cooperates?)
  end

  def all_players_betray?
    players.all?(&:betrays?)
  end

  def traitors_and_naives?
    players.any?(&:cooperates?) && players.any?(&:betrays?)
  end

  def pay_max_to_traitors_and_min_to_naives
    traitors, naives = retrieve_traitors_and_naives
    traitors.each { |traitor| earning_engine.give_max_earning_to(traitor) }
    naives.each { |naive| earning_engine.give_min_earning_to(naive) }
  end

  def retrieve_traitors_and_naives
    traitors, naives = @players.partition(&:betrays?)
    [traitors, naives]
  end
end
