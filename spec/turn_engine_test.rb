require_relative 'spec_helpers'
require_relative '../lib/game_theory/turn_engine_class'

class TurnEngineTest < Minitest::Test
  def setup
    @player1 = Minitest::Mock.new
    @player2 = Minitest::Mock.new
    @players = [@player1, @player2]
    @game_logic = Minitest::Mock.new
    @history = Minitest::Mock.new
    @turn_engine = TurnEngine.new(@game_logic, @history)
  end

  def test_it_has_players_and_game_logic_attribute_readers
    assert_respond_to(@turn_engine, :players)
    assert_respond_to(@turn_engine, :game_logic)
  end

  def test_it_has_players_attribue_set_to_nil_on_initialisation
    assert_nil @turn_engine.players
  end

  def test_it_has_a_game_logic_attribute_set_to_an_object_on_initialisation
    assert_equal @game_logic.object_id, @turn_engine.game_logic.object_id
  end

  def test_it_can_assigns_players_to_self_and_game_logic
    @game_logic.expect(:assign_players, nil, [@players])
    @history.expect(:assign_players, nil, [@players])
    @turn_engine.assign_players(@players)
    assert_equal @players, @turn_engine.players
    @game_logic.verify
    @history.verify
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def test_play_turn_method_actually_play_the_whole_turn
    skip
    @game_logic.expect(:assign_players, nil, [@players])
    @history.expect(:assign_players, nil, [@players])

    turn1 = TurnEngine::Turn.new(name: 'roro', behavior: :random,
                                 move: 'trahit', score: 10, earning: 0)
    turn2 = TurnEngine::Turn.new(name: 'roro', behavior: :random,
                                 move: 'trahit', score: 10, earning: 0)

    @history.expect(:store_turn, nil, [[turn1, turn2]])
    @turn_engine.assign_players(@players)

    @players.each do |player|
      player.expect(:play_move, nil)
      player.expect(:reset_move, nil)
      player.expect(:reset_turn_earning, nil)
      player.expect(:name, 'roro')
      player.expect(:behavior, :random)
      player.expect(:display_move, 'trahit')
      player.expect(:score, 10)
      player.expect(:turn_earning, 0)
    end

    @game_logic.expect(:process_moves, nil)

    @turn_engine.play_turn
    @players.each(&:verify)
    @game_logic.verify
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def test_it_can_reset_player_scores
    @game_logic.expect(:assign_players, nil, [@players])
    @history.expect(:assign_players, nil, [@players])
    @turn_engine.assign_players(@players)

    @players.each { |player| player.expect(:reset_score, nil) }
    @turn_engine.reset_players_score
    @players.each(&:verify)
  end
end
