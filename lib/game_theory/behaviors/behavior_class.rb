# Abstrcat class for the different behaviors
class Behavior
  attr_reader :history

  def initialize(history)
    @history = history
    post_initialize
  end

  def to_s
    raise 'Not Implemented yet'
  end

  def choose_move(_player)
    raise 'Not Implemented yet'
  end
end
