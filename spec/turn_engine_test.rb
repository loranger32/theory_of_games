require_relative 'spec_helpers'
require_relative '../lib/game_theory/turn_engine_class'

class GameTurnEngineInitialisationTest < Minitest::Test
  def setup
    @player1 = Minitest::Mock.new
    @player2 = Minitest::Mock.new
    @players = [@player1, @player2]
    @game_logic = Minitest::Mock.new
    @turn_engine = TurnEngine.new([@player1, @player2], @game_logic)
  end

  def test_it_has_players_and_game_logic_attribute_readers
    assert_equal @players, @turn_engine.players
    assert_equal @game_logic.object_id, @turn_engine.game_logic.object_id
  end

  def test_play_turn_actually_play_the_whole_turn
    @players.each do |player|
      player.expect(:play_move, nil)
      player.expect(:reset_move, nil)
    end

    @game_logic.expect(:process_moves, nil)

    @turn_engine.play_turn
    @players.each(&:verify)
    @game_logic.verify
  end

  def test_it_can_reset_player_scores
    @players.each { |player| player.expect(:reset_score, nil) }
    @turn_engine.reset_players_score
    @players.each(&:verify)
  end
end
