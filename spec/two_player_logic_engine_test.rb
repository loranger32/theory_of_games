require 'pry'

require_relative 'spec_helpers'
require_relative '../lib/game_theory/two_player_logic_class'

class TwoPlayerLogicTest < Minitest::Test
  def create_players_mock
    @player1 = Minitest::Mock.new
    @player2 = Minitest::Mock.new
    [@player1, @player2]
  end

  def setup
    @players = create_players_mock
    @earning_engine = Minitest::Mock.new
    @logic_engine = TwoPlayerLogic.new(@players, @earning_engine)
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

  def test_process_move_give_appropriate_earnings_to_traitor_and_naive
    2.times do
      @player1.expect(:betrays?, true)
      @player1.expect(:cooperates?, false)

      @player2.expect(:betrays?, false)
      @player2.expect(:cooperates?, true)
    end

    @player1.expect(:betrays?, true)
    @player2.expect(:betrays?, false)

    # Needs to pass an Object as argument, otherwise returns an error
    # I think it's due to Minitest internals, and Mock in particular
    @earning_engine.expect(:give_max_earning_to, nil, [Object])
    @earning_engine.expect(:give_min_earning_to, nil, [Object])

    @logic_engine.process_moves

    @earning_engine.verify
  end
end
