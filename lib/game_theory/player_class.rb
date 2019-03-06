# The classic player class
class Player
  attr_reader :name, :behavior
  attr_accessor :move

  def initialize(score:, behavior:, name:)
    @score = score
    @behavior = behavior
    @name = name
    @move = nil
  end

  def play_move
    self.move = behavior.choose_move
  end

  def cooperates?
    move == :cooperates
  end

  def betrays?
    move == :betrays
  end

  def score
    @score.total
  end

  def turn_earning
    @score.turn_earning
  end

  def earn_max
    @score.earn_max
  end

  def earn_medium
    @score.earn_medium
  end

  def earn_min
    @score.earn_min
  end

  def reset_move
    @move = nil
  end

  def reset_score
    @score.reset!
  end

  def reset_turn_earning
    @score.reset_turn_earning!
  end

  def display
    puts self
  end

  def to_s
    <<~PLAYER
      Nom: #{name}
      Comportement: #{behavior}
    PLAYER
  end
end
