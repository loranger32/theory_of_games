require_relative 'spec_helpers'
require_relative '../lib/game_theory/player_factory_class'

class PlayerFactoryTest < Minitest::Test
  
  class Behavior; end

  ####### Setup

  def setup
    @player_class     = Minitest::Mock.new
    @score_class      = Minitest::Mock.new
    @behavior_class   = PlayerFactoryTest::Behavior
    @behavior_mock1   = PlayerFactoryTest::Behavior.new
    @behavior_mock2   = PlayerFactoryTest::Behavior.new
    @player_factory   = PlayerFactory.new(@player_class, @score_class,
                                          @behavior_class)
    # Needs four expects - 2 for the player_class mock creation and 2 for the
    # actual method call in create_players
    4.times { @score_class.expect(:new, :score_instance) }
  end

  ####### Helper Methods

  def valid_player_1_data
    { name: 'Test Player One', behavior: @behavior_mock1 }
  end

  def valid_player_2_data
    { name: 'Test Player Two', behavior: @behavior_mock2 }
  end

  def mock_player_class(player_1_data, player_2_data)
    player1_params = player_1_data.merge(score_recorder: @score_class.new)
    player2_params = player_2_data.merge(score_recorder: @score_class.new)
    @player_class.expect(:new, :player1,[player1_params])
    @player_class.expect(:new, :player2,[player2_params])
  end

  ####### Tests

  def test_it_respond_to_create_players
    assert_respond_to(@player_factory, :create_players)
  end

  def test_create_players_with_valid_players_data
    mock_player_class(valid_player_1_data, valid_player_2_data)

    players = @player_factory.create_players([valid_player_1_data,
                                              valid_player_2_data])

    assert_equal [:player1, :player2], players
    @player_class.verify
    @score_class.verify
  end

  def test_it_raises_error_if_player_data_is_not_a_hash
    assert_raises PlayerFactoryArgumentError do
      @player_factory.create_players([:invalid, :invalid])
    end
  end

  def test_it_raises_error_with_player_data_without_name_key
    invalid_player_1_data = { behavior: @behavior_mock1 }

    assert_raises PlayerFactoryArgumentError do
      @player_factory.create_players([invalid_player_1_data,
                                      valid_player_2_data])
    end
  end

  def test_it_raises_error_with_player_data_without_behavior_key
    assert_raises PlayerFactoryArgumentError do
      @player_factory.create_players([{ name: 'Test Player 1' },
                                      valid_player_2_data])
    end
  end

  def test_it_raises_error_if_name_value_is_not_string
    invalid_player_1_data = { name: :invalid_format, behavior: @behavior_mock1 }

    assert_raises PlayerFactoryArgumentError do
      @player_factory.create_players([invalid_player_1_data,
                                      valid_player_2_data])
    end
  end

  def test_it_raises_error_if_bahavior_value_is_not_a_behavior
    invalid_player_1_data = { name: 'Test Player 1',
                              behavior: :invalid_behavior }

    assert_raises PlayerFactoryArgumentError do
      @player_factory.create_players([invalid_player_1_data,
                                      valid_player_2_data])
    end
  end

  def test_it_can_reset_players
    mock_player_class(valid_player_1_data, valid_player_2_data)

    players = @player_factory.create_players([valid_player_1_data,
                                              valid_player_2_data])

    assert_equal [:player1, :player2], players
    @player_factory.reset!
    assert_empty @player_factory.send(:players)
  end
end
