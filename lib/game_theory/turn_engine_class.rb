class TurnEngine
  
  attr_reader :players, :game_logic

  def initialize(players, game_logic)
    @players = players
    @game_logic = game_logic
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
