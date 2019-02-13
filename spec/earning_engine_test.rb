require_relative 'spec_helpers'
require_relative '../lib/game_theory/earning_engine_class'

class EaringEngineTest < Minitest::Test

  def create_players_mock
    @player1 = Minitest::Mock.new
    @player2 = Minitest::Mock.new
    @players = [@player1, @player2]
  end

  def setup
    @earning_engine = EarningEngine.new(create_players_mock)
  end

  def test_give_each_player_medium_earnings
    @players.map { |player| player.expect(:earn_medium, nil) }
    @earning_engine.give_each_player_medium_earning
    @players.each { |player| player.verify }
  end

  def test_give_each_player_minimum_earnings
    @players.map { |player| player.expect(:earn_min, nil) }
    @earning_engine.give_each_player_minimum_earning
    @players.each { |player| player.verify }
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
