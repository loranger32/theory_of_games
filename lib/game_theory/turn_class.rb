# A class to model turns to be stored in the history instance
class Turn

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
