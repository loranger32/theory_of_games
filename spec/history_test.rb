require_relative 'spec_helpers'
require_relative '../lib/game_theory/history_class'

class HistoryTest < Minitest::Test
  def setup
    @player1 = Minitest::Mock.new
    @player2 = Minitest::Mock.new
    @players = [@player1, @player2]
    @history = History.new
  end

  def test_it_responds_to_players
    assert_respond_to(@history, :players)
  end

  def test_it_responds_to_assign_players
    assert_respond_to(@history, :assign_players)
  end

  def test_it_respond_to_turns
    assert_respond_to(@history, :turns)
  end

  def test_it_respond_to_store_turn
    assert_respond_to(@history, :store_turn)
  end

  def test_it_can_assign_players
    @history.assign_players(@players)
    assert_equal @players, @history.players
  end
end
