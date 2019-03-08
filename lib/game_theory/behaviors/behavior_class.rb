# Error class to signal the attempt to instantiate the abstract class
class AbstractBehaviorClassError < StandardError; end

# Abstrcat class for the different behaviors
class Behavior
  attr_reader :history, :type

  def initialize(history)
    @history = history
    post_initialize
  end

  def to_s
    raise AbstractBehaviorClassError,
          'Method must be implemented by the concrete class'
  end

  def choose_move(_player)
    raise AbstractBehaviorClassError,
          'Method must be implemented by the concrete class'
  end

  private

  def post_initialize
    @type = :abstract_behavior_class
  end
end
