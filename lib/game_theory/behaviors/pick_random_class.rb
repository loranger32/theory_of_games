class PickRandom < Behavior
  def post_initialize
    @type = :random
  end

  def choose_move(_player)
    rand(0..1).zero? ? :betrays : :cooperates
  end

  def to_s
    'au hasard'
  end
end
