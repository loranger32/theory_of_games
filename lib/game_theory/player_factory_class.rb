class PlayerFactory
  def initialize(player_class)
    @player_class = player_class
  end

  def generate_players
    @player1 = @player_class.new
    @player2 = @player_class.new
    [@player1, @player2]
  end
end
