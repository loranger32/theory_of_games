class TurnEngine
  
  attr_reader :game_logic, :players

  def initialize(game_logic)
    @players = nil
    @game_logic = game_logic
  end

  def assign_players(players)
    @players = players
    game_logic.assign_players(players)
  end

  def play_turn
    @players.each { |player| player.play_move }
    game_logic.process_moves
    reset_players_move
  end

  def reset_players_score
    @players.each(&:reset_score)
  end

  private

  def reset_players_move
    @players.map(&:reset_move)
  end
end
