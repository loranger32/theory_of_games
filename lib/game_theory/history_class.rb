# A class to store the turns results
class History
  include Displayable
  include Enumerable

  attr_reader :players, :turns
  
  def initialize
    @players = nil
    @turns = []
  end

  def assign_players(players)
    @players = players
  end

  def store_turn(turn)
    turns << turn
  end

  def each
    turns.each do |turn|
      yield turn
    end
  end

  def display
    each_with_index do |turn, index|
      print_message("=" * 30)
      print_message("TOUR #{index + 1} :")
      turn.each do |_, player_turn|
        print_message(player_turn)
      end
    end
  end
end
