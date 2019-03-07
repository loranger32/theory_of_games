require_relative 'spec_helpers'
require_relative '../lib/game_theory/displayable_module'
require_relative '../lib/game_theory/validable_module'
require_relative '../lib/game_theory/history_class'

class HistoryTest < Minitest::Test
  def setup
    @player1 = Minitest::Mock.new
    @player2 = Minitest::Mock.new
    @players = [@player1, @player2]
    @turn1 = Minitest::Mock.new
    @turn2 = Minitest::Mock.new
    @history = History.new
  end

  def test_it_has_a_player_attribute
    assert_respond_to(@history, :players)
  end

  def test_it_assigns_players
    @history.assign_players(@players)
    assert_equal @players, @history.players
  end

  def test_it_has_a_turn_attribute
    assert_kind_of(Array, @history.turns)
  end

  def test_it_can_store_turns
    @history.store_turn(@turn1)
    @history.store_turn(@turn2)
    turns = [@turn1, @turn2]
    assert_equal(turns, @history.turns)
  end

  def test_it_can_fetch_last_turn
    @history.store_turn(@turn1)
    @history.store_turn(@turn2)
    assert_equal @turn2.object_id, @history.last_turn.object_id
  end

  def test_it_respond_to_each
    @history.store_turn(@turn1)
    @history.store_turn(@turn2)
    turns = [@turn1, @turn2]
    turns.each { |turn| turn.expect(:i_am_yielded_to_the_block, nil) }
    @history.each do |turn|
      assert_respond_to(turn, :i_am_yielded_to_the_block)
    end
  end

  def test_it_respond_to_display
    assert_respond_to(@history, :display)
  end
end
