# Concrete class for the Traitor class
class Traitor < Behavior
  def post_initialize
    @type = :traitor
  end

  def choose_move(_player)
    :betrays
  end

  def to_s
    'trahit'
  end
end
