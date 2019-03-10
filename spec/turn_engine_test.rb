require_relative 'spec_helpers'
require_relative '../lib/game_theory/turn_engine_class'

module TurnEngineTestHelper
  def general_setup
    @player1     = Minitest::Mock.new
    @player2     = Minitest::Mock.new
    @players     = [@player1, @player2]
    @game_logic  = Minitest::Mock.new
    @history     = Minitest::Mock.new
    @turn_class  = Minitest::Mock.new
    @turn_engine = TurnEngine.new(@game_logic, @history, @turn_class)
  end

  def set_up_players_for_turn
    @players.each do |player|
      player.expect(:play_move, nil)
      player.expect(:reset_turn_earning, nil)
      player.expect(:reset_move, nil)
    end
  end

  def set_up_game_logic_for_turn
    @game_logic.expect(:assign_players, nil, [@players])
    @game_logic.expect(:process_moves, nil)
  end

  def set_up_history_for_turn
    @history.expect(:assign_players, nil, [@players])
    @history.expect(:store_turn, nil, [:result])
  end

  def set_up_mocks_for_turn
    set_up_players_for_turn
    set_up_game_logic_for_turn
    set_up_history_for_turn
    
    @turn_class.expect(:create_turn_records, :result, [@players])
  end
end

class TurnEngineBasicsTest < Minitest::Test
  include TurnEngineTestHelper

  def setup
    general_setup      
  end

  def test_it_has_a_game_logic_reader_accessor
    assert_equal @game_logic.object_id, @turn_engine.game_logic.object_id
  end

  def test_it_has_a_history_reader_accessor
    assert_equal @history.object_id, @turn_engine.history.object_id
  end

  def test_it_has_a_turn_class_reader_aaccessor
    assert_equal @turn_class.object_id, @turn_engine.turn_class.object_id
  end

  def test_it_has_players_attribue_set_to_nil_on_initialisation
    assert_nil @turn_engine.players
  end

  def test_it_has_a_game_logic_attribute_set_to_an_object_on_initialisation
    assert_equal @game_logic.object_id, @turn_engine.game_logic.object_id
  end

  def test_it_can_assigns_players
    @game_logic.expect(:assign_players, nil, [@players])
    @history.expect(:assign_players, nil, [@players])
    @turn_engine.assign_players(@players)
    assert_equal @players, @turn_engine.players
    @game_logic.verify
    @history.verify
  end
end

class TurnEngineOperationsTest < Minitest::Test
  include TurnEngineTestHelper

  def setup
    general_setup
    @game_logic.expect(:assign_players, nil, [@players])
    @history.expect(:assign_players, nil, [@players])
    @turn_engine.assign_players(@players)
  end

  def test_it_can_reset_players_scores
    @players.each { |player| player.expect(:reset_score, nil) }
    @turn_engine.reset_players_score
    @players.each(&:verify)
  end

  def test_it_can_reset_players_turns_earning
    @players.each { |player| player.expect(:reset_turn_earning, nil) }
    @turn_engine.reset_players_turn_earning
    @players.each(&:verify)
  end

  def test_it_can_reset_history
    @history.expect(:reset!, nil)
    @turn_engine.reset_history!
    @history.verify
  end

  def test_it_can_reset_players_move
    @players.each { |player| player.expect(:reset_move, nil) }
    @turn_engine.reset_players_move
    @players.each(&:verify)
  end

  def test_it_can_store_turn
    @turn_class.expect(:create_turn_records, :result, [@players])
    @history.expect(:store_turn, nil, [:result])    

    @turn_engine.store_turn
    @history.verify
    @turn_class.verify
  end

  def test_play_turn_method_actually_play_the_whole_turn
    set_up_mocks_for_turn
    
    @turn_engine.assign_players(@players)

    @turn_engine.play_turn
    @players.each(&:verify)
    @game_logic.verify
    @turn_class.verify
    @history.verify
  end
end
