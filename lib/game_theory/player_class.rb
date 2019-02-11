class Player

  MAX_GAIN = 5
  MEDIUM_GAIN = 3
  NO_GAIN = 0

  def initialize(name: 'random', player_type: :random)
    @name = name
    @player_type = player_type
    @move = nil
    @score = 0
  end

  def play_move
    @move = case @player_type
            when :cooperator then :cooperates
            when :traitor then :betrays
            when :random then choose_random_move
            else
              :do_not_know
            end
  end

  def cooperates?
    @move == :cooperates
  end

  def betrays?
    @move == :betrays
  end

  def earn_max
    @score += MAX_GAIN
  end

  def earn_medium
    @score += MEDIUM_GAIN
  end

  def loose
    @score += NO_GAIN
  end

  def choose_random_move
    rand(0..1) == 0 ? :betrays : :cooperates
  end

  def reset_move
    @move = nil
  end
end


good_guy = Player.new(name: 'Good guy', player_type: :cooperator)
bad_guy = Player.new(name: 'Bad guy', player_type: :traitor)

good_guy.play_move
bad_guy.play_move

p good_guy.cooperates?
p bad_guy.betrays?


