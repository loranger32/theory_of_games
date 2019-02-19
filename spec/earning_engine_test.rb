require_relative 'spec_helpers'
require_relative '../lib/game_theory/earning_engine_class'

class EaringEngineTest < Minitest::Test
  def create_players_mock
    @player1 = Minitest::Mock.new
    @player2 = Minitest::Mock.new
    @players = [@player1, @player2]
  end

  def setup
    @earning_engine = EarningEngine.new
    create_players_mock
    @earning_engine.assign_players(@players)
  end

  def test_it_has_a_players_attribute_reader_method
    assert_respond_to @earning_engine, :players
  end

  def test_it_has_a_player_attribute_initialized_to_nil
    assert_nil EarningEngine.new.players
  end

  def test_assign_players_to_self
    assert_equal @players, @earning_engine.players
  end

  def test_give_each_player_medium_earnings
    @players.map { |player| player.expect(:earn_medium, nil) }
    @earning_engine.give_each_player_medium_earning
    @players.each(&:verify)
  end

  def test_give_each_player_minimum_earnings
    @players.map { |player| player.expect(:earn_min, nil) }
    @earning_engine.give_each_player_minimum_earning
    @players.each(&:verify)
  end

  def test_give_max_earning_to_traitor
    @player1.expect(:earn_max, nil)
    @earning_engine.give_max_earning_to(@player1)
    @player1.verify
  end

  def test_give_min_earning_to_naive
    @player2.expect(:earn_min, nil)
    @earning_engine.give_min_earning_to(@player2)
    @player2.verify
  end
end
