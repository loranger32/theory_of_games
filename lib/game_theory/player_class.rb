class Player

  MAX_GAIN = 5
  MEDIUM_GAIN = 3
  MIN_GAIN = 0

  attr_reader :name, :behavior, :score, :move

  def initialize(name: 'random', behavior: :random)
    @name = name
    @behavior = behavior
    @move = nil
    @score = 0
  end

  def play_move
    @move = case @behavior
            when :cooperator then :cooperates
            when :traitor then :betrays
            when :random then choose_random_move
            else
              :do_not_know
            end
  end

  def cooperates?
    @move == :cooperates
  end

  def betrays?
    @move == :betrays
  end

  def earn_max
    @score += MAX_GAIN
  end

  def earn_medium
    @score += MEDIUM_GAIN
  end

  def earn_min
    @score += MIN_GAIN
  end

  def reset_move
    @move = nil
  end

  def reset_score
    @score = 0
  end

  private

  def choose_random_move
    rand(0..1) == 0 ? :betrays : :cooperates
  end
end
