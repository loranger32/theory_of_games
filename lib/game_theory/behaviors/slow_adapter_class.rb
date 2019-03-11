# Concrete class for the slow adapter behavior
class SlowAdapter < Behavior
  def post_initialize
    @type = :slow_adapter
  end

  def choose_move(player)
    if history.less_than_three_turns?
      :cooperates
    elsif history.traitor_on_last_three_turns?(player)
      :betrays
    elsif history.naive_on_last_three_turns?(player)
      :cooperates
    else
      history.pick_last_move_of_player(player)
    end
  end

  def to_s
    'adapte lentement'
  end
end
