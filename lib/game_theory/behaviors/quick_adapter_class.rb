class QuickAdapter < Behavior
  def post_initialize
    @type = :quick_adapter
  end

  def choose_move(player)
    if history.empty?
      :cooperates
    else
      history.traitor_on_last_turn?(player) ? :betrays : :cooperates
    end
  end

  def to_s
    'adapte rapidement'
  end
end
