require_relative 'spec_helpers'
require_relative '../lib/game_theory/game_turn_engine_class'

# WIP

class GameTurnEngineInitialisationTest < Minitest::Test
  def setup
    @player1 = Minitest::Mock.new
    
    @player2 = Minitest::Mock.new
    @player2.expect(:cooperates?, true)
  end

  def test_it_take_one_array_as_unique_argument_test
    assert_silent { GameTurnEngine.new([@player1, @player2]) }
  end
end
