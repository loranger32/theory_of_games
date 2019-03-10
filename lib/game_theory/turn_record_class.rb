# A class to model turns to be stored in the history instance
class TurnRecord

  def self.create_turn_records(players)
    players.each_with_object([]) do |player, container|
      container << new(name: player.name, move: player.move,
                       display_move: player.display_move,
                       earning: player.turn_earning,
                       behavior: player.behavior,
                       score: player.score)
    end
  end

  attr_reader :name, :move, :display_move, :earning, :behavior, :score

  def initialize(name:, move:, display_move:, earning:, behavior:, score:)
    @name         = name
    @move         = move
    @display_move = display_move
    @earning      = earning
    @behavior     = behavior
    @score        = score
  end

  def to_s
    <<~TURN
      #{name}:
      - behavior : #{behavior}
      - move : #{display_move}
      - earning : #{earning}
      - score : #{score}
      --------------------------
    TURN
  end

  def a_traitor?
    move == :betrays
  end

  def a_naive?
    move == :cooperates
  end
end
