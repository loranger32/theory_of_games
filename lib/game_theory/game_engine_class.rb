class GameEngine
  def initialize(players)
    @players = players
  end

  def play_turn
    @players.each { |player| player.play_move }
    process_moves
    distribute_points
  end

  private

  def compare_moves
  end
end
