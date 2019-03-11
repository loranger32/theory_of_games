require_relative 'spec_helpers'
require_relative '../lib/game_theory/logic_engine_class'

class LogicEngineTest < Minitest::Test
  def create_players_mock
    @player1 = Minitest::Mock.new
    @player2 = Minitest::Mock.new
    @player3 = Minitest::Mock.new
    [@player1, @player2, @player3]
  end

  def setup
    @players = create_players_mock
    @earning_engine = Minitest::Mock.new
    @earning_engine.expect(:assign_players, nil, [@players])
    @logic_engine = LogicEngine.new(@earning_engine)
    @logic_engine.assign_players(@players)
  end

  def test_it_has_a_players_attributes_set_to_nil_on_instantiation
    assert_nil LogicEngine.new(@earning_engine).send(:players)
  end

  def test_it_assigns_players_to_self
    assert_equal @players, @logic_engine.send(:players)
  end

  def test_it_assigns_players_to_earning_engine
    # assignment occurs in setup - simply verify it here
    @earning_engine.verify
  end

  def test_process_move_give_all_players_medium_amount_if_they_cooperate
    @players.map { |player| player.expect(:cooperates?, true) }
    @players.map { |player| player.expect(:betrays?, false) }

    @earning_engine.expect(:give_each_player_medium_earning, nil)

    @logic_engine.process_moves

    @earning_engine.verify
  end

  def test_process_move_give_all_players_minimum_earning_if_they_all_betray
    @players.map { |player| player.expect(:cooperates?, false) }
    @players.map { |player| player.expect(:betrays?, true) }

    @earning_engine.expect(:give_each_player_minimum_earning, nil)

    @logic_engine.process_moves

    @earning_engine.verify
  end

  # rubocop:disable Metrics/MethodLength
  def test_process_move_give_appropriate_earnings_to_mixed_two_players
    3.times do
      @player1.expect(:betrays?, true)
      @player1.expect(:cooperates?, false)

      @player2.expect(:betrays?, false)
      @player2.expect(:cooperates?, true)

      @player3.expect(:betrays?, false)
      @player3.expect(:cooperates?, true)
    end

    @earning_engine.expect(:give_max_earning_to, true, [@player1])
    @earning_engine.expect(:give_min_earning_to, true, [@player2])
    @earning_engine.expect(:give_min_earning_to, true, [@player3])

    @logic_engine.process_moves

    @earning_engine.verify
  end
end
# rubocop:enable Metrics/MethodLength
