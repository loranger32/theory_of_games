require_relative 'spec_helpers'
require_relative '../lib/game_theory/turn_engine_class'

class GameTurnEngineInitialisationTest < Minitest::Test
  def setup
    @player1 = Minitest::Mock.new
    @player2 = Minitest::Mock.new
    @game_logic = Minitest::Mock.new
  end

  def test_it_take_one_array_as_unique_argument_test
    assert_silent { TurnEngine.new([@player1, @player2], @game_logic) }
  end
end
