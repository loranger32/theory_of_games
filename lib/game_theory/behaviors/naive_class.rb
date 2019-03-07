class Naive < Behavior
  puts 'I am loaded'
  def post_initialize
    @type = :naive
  end

  def choose_move(_player)
    :cooperates
  end

  def to_s
    'coopère'
  end
end
