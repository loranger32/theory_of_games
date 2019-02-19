require_relative 'spec_helpers'
require_relative '../lib/game_theory/displayable_module'
require_relative '../lib/game_theory/player_factory_class'

class PlayerFactory
  def ask_how_many_players_will_play
    3
  end

  def create_player_times(number_of_players)
    result = []
    number_of_players.times { result << Object }
    result
  end
end

class PlayerFactoryTest < Minitest::Test
  def setup
    @player_class = Minitest::Mock.new
    @score_class = Minitest::Mock.new
    @player_factory = PlayerFactory.new(@player_class, @score_class)
  end

  def test_create_players
    # Assume the number of players to create is 3

    expected = [Object, Object, Object]
    assert_equal expected, @player_factory.create_players
  end
end
