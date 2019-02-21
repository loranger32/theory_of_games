require_relative 'spec_helpers'
require_relative '../lib/game_theory/displayable_module'
require_relative '../lib/game_theory/player_factory_class'

class PlayerFactory
  def ask_number_of_players_to_create
    2
  end
end

class PlayerFactoryTest < Minitest::Test
  def setup
    @player_class = Minitest::Mock.new
    @score_class = Minitest::Mock.new
    @name_engine = Minitest::Mock.new
    @behavior_engine = Minitest::Mock.new
    @player_factory = PlayerFactory.new(@player_class, @score_class,
                                        @name_engine, @behavior_engine)
  end

  def test_create_players
    @player1 = Minitest::Mock.new
    @player2 = Minitest::Mock.new

    @name_engine.expect(:choose_player_name, "Roger", [1])
    @name_engine.expect(:choose_player_name, "Tim", [2])

    4.times { @score_class.expect(:new, Object) }

    2.times { @behavior_engine.expect(:choose_player_behavior, :random) }

    @player_class.expect(:new, @player1, [@score_class.new, name: "Roger",
                                          behavior: :random])

    @player_class.expect(:new, @player2, [@score_class.new, name: "Tim",
                                          behavior: :random])

    assert_equal [@player1, @player2], @player_factory.create_players

    [@name_engine, @behavior_engine, @player_class].each(&:verify)
  end
end
