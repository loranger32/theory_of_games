# The classic player class
class Player
  attr_reader :name, :behavior, :move

  def initialize(score, name: 'random', behavior: :random)
    @score = score
    @name = name
    @behavior = behavior
    @move = nil
  end

  def play_move
    @move = case @behavior
            when :naive      then :cooperates
            when :traitor    then :betrays
            when :random     then choose_random_move
            else
              :do_not_know
            end
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

  private

  def choose_random_move
    rand(0..1).zero? ? :betrays : :cooperates
  end
end
