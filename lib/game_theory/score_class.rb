# Class to manage and remeber score of players
class Score
  MIN_GAIN    = 0
  MEDIUM_GAIN = 3
  MAX_GAIN    = 5

  attr_reader :turn_earning, :total

  def initialize
    @turn_earning = 0
    @total        = 0
  end

  def earn_min
    @turn_earning = MIN_GAIN
    @total       += MIN_GAIN
  end

  def earn_max
    @turn_earning = MAX_GAIN
    @total       += MAX_GAIN
  end

  def earn_medium
    @turn_earning = MEDIUM_GAIN
    @total       += MEDIUM_GAIN
  end

  def reset_turn_earning!
    @turn_earning = 0
  end

  def reset!
    @total = 0
  end
end
