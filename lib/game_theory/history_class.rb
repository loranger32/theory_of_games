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

  def empty?
    turns.empty?
  end

  def each
    turns.each do |turn|
      yield turn
    end
  end

  def last_turn
    turns.last
  end

  def last_three_turns
    turns[-3..-1]
  end

  def has_less_than_three_turns?
    turns.size < 3
  end

  def has_a_traitor_on_last_turn?(player)
    last_turn.any? do |player_turn|
      next if player_turn.name == player.name
      player_turn.has_a_traitor?
    end
  end

  def has_a_traitor_on_last_three_turns?(player)
    last_three_turns.all? do |turn|
      last_turn.any? do |player_turn|
        next if player_turn.name == player.name
        player_turn.has_a_traitor?
      end 
    end
  end

  def display
    each_with_index do |turn, index|
      print_message('=' * 30)
      print_message("TOUR #{index + 1} :")
      display_in_table(turn, :name, :behavior, :move, :earning, :score)
    end
  end

  def reset!
    @turns = []
  end
end
