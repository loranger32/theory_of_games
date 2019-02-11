class GameTurnEngine
  def initialize(players)
    @players = players
  end

  def play_turn
    @players.each { |player| player.play_move }
    process_moves
  end

  private

  def process_moves
    if players.all(&:cooperates?)
      players.map(&:earn_medium)
    elsif players.all(&:betrays?)
      players.map(&:loose)
    else
      winner, loser = players.partition { |player| player.betrays? }
      winner.earn_max
      loser.loose
    end
  end
end
