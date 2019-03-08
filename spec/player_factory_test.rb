require_relative 'spec_helpers'
require_relative '../lib/game_theory/displayable_module'
require_relative '../lib/game_theory/validable_module'
require_relative '../lib/game_theory/player_factory_class'

class PlayerFactory
  # stub for the actual method with a simple valid return value
  def ask_number_of_players_to_create
    2
  end
end

class PlayerFactoryTest < Minitest::Test
  def setup
    @player_class     = Minitest::Mock.new
    @score_class      = Minitest::Mock.new
    @name_engine      = Minitest::Mock.new
    @behavior_factory = Minitest::Mock.new
    @player_factory   = PlayerFactory.new(@player_class, @score_class,
                                          @name_engine, @behavior_engine)
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def test_create_players
    skip
    @player_factory.input = StringIO.new('o')

    @player1 = Minitest::Mock.new
    @player2 = Minitest::Mock.new
    players = [@player1, @player2]
    players.each do |player|
      player.expect(:name, nil)
      player.expect(:behavior, nil)
    end

    @name_engine.expect(:choose_player_name, 'Roger', [1])
    @name_engine.expect(:choose_player_name, 'Tim', [2])

    4.times { @score_class.expect(:new, Object) }

    2.times { @behavior_engine.expect(:choose_player_behavior, :random) }

    @player_class.expect(:new, @player1,
                         [score: @score_class.new, name: 'Roger',
                          behavior: :random])

    @player_class.expect(:new, @player2,
                         [score: @score_class.new, name: 'Tim',
                          behavior: :random])

    capture_io do
      assert_equal players, @player_factory.create_players
    end

    [@name_engine, @behavior_engine, @player_class].each(&:verify)
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
