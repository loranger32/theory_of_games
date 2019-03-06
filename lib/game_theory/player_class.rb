# The classic player class
class Player
  attr_reader :name, :behavior, :score_recorder
  attr_accessor :move

  def initialize(score:, behavior:, name:)
    @score_recorder = score
    @behavior = behavior
    @name = name
    @move = nil
  end

  def play_move
    self.move = behavior.choose_move(self)
  end

  def cooperates?
    move == :cooperates
  end

  def betrays?
    move == :betrays
  end

  def score
    score_recorder.total
  end

  def turn_earning
    score_recorder.turn_earning
  end

  def earn_max
    score_recorder.earn_max
  end

  def earn_medium
    score_recorder.earn_medium
  end

  def earn_min
    score_recorder.earn_min
  end

  def reset_move
    self.move = nil
  end

  def reset_score
    score_recorder.reset!
  end

  def reset_turn_earning
    score_recorder.reset_turn_earning!
  end

  def display
    puts self
  end

  def display_move
    case move
    when :cooperates then 'coopère'
    when :betrays    then 'trahit'
    else
      'action inconnue'
    end
  end

  def to_s
    <<~PLAYER
      Nom: #{name}
      Comportement: #{behavior}
    PLAYER
  end
end
