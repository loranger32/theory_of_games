class GameTurnEngine
  def initialize(players)
    @players = players
  end

  def play_turn
    @players.each { |player| player.play_move }
    process_moves
    reset_players_move
  end

  private

  def process_moves
    if players.all(&:cooperates?)
      players.map(&:earn_medium)
    elsif players.all(&:betrays?)
      players.map(&:earn_min)
    else
      winner, loser = players.partition { |player| player.betrays? }
      winner.earn_max
      loser.earn_min
    end
  end

  def reset_players_move
    @players.map(&:reset_move)
  end
end
