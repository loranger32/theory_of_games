# The engine responsible for manging turns
class TurnEngine
  attr_reader :game_logic, :players, :history, :turn_class

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

  def reset_players_turn_earning
    players.each(&:reset_turn_earning)
  end

  def reset_history!
    @history.reset!
  end

  def store_turn
    formatted_turn = format_turn(players)
    history.store_turn(formatted_turn)
  end

  private

  def reset_players_move
    @players.map(&:reset_move)
  end

  def format_turn(players)
    players.each_with_object([]) do |player, container|
      container << turn_class.new(name: player.name, move: player.move,
                                  display_move: player.display_move,
                                  earning: player.turn_earning, 
                                  behavior: player.behavior,
                                  score: player.score)
    end
  end
end
