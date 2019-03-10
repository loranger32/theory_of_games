# The engine responsible for manging turns
class TurnEngine
  attr_reader :players, :game_logic, :history, :turn_class

  def initialize(game_logic, history, turn_class)
    @players    = nil
    @game_logic = game_logic
    @history    = history
    @turn_class = turn_class
  end

  def assign_players(players)
    @players = players
    game_logic.assign_players(players)
    history.assign_players(players)
  end

  def play_turn
    players.each(&:play_move)
    game_logic.process_moves
    store_turn
    reset_players_turn_earning
    reset_players_move
  end

  def reset_players_score
    players.each(&:reset_score)
  end

  def reset_players_move
    @players.map(&:reset_move)
  end

  def reset_players_turn_earning
    players.each(&:reset_turn_earning)
  end

  def reset_history!
    @history.reset!
  end

  def store_turn
    formatted_turn = turn_class.create_turn_records(players)
    history.store_turn(formatted_turn)
  end
end
