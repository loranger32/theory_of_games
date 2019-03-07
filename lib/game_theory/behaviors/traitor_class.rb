class Traitor < Behavior
  puts "I'm loaded too !!!"
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
