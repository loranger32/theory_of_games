class Score
  MIN_GAIN    = 0
  MEDIUM_GAIN = 3
  MAX_GAIN    = 5

  attr_reader :total

  def initialize
    @total = 0
  end

  def earn_min
    @total += MIN_GAIN
  end

  def earn_max
    @total += MAX_GAIN
  end

  def earn_medium
    @total += MEDIUM_GAIN
  end

  def reset!
    @total = 0
  end
end
