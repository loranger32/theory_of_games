require_relative 'spec_helpers'
require_relative '../lib/game_theory/turn_engine_class'

class GameTurnEngineInitialisationTest < Minitest::Test
  def setup
    @player1 = Minitest::Mock.new
    @player2 = Minitest::Mock.new
    @players = [@player1, @player2]
    @game_logic = Minitest::Mock.new
  end

  def test_it_can_be_initialized_with_one_array_of_players_and_the_game_logic
    assert_silent { TurnEngine.new([@player1, @player2], @game_logic) }
  end

  def test_play_turn_actually_play_the_whole_turn
    @players.each do |player|
      player.expect(:play_move, nil)
      player.expect(:reset_move, nil)
    end

    @game_logic.expect(:process_moves, nil)

    turn_engine = TurnEngine.new([@player1, @player2], @game_logic)
    turn_engine.play_turn
    @players.each(&:verify)
    @game_logic.verify
  end
end
