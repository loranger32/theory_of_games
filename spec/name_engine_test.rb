require_relative 'spec_helpers'
require_relative '../lib/game_theory/displayable_module'
require_relative '../lib/game_theory/name_engine_class'

RANDOM_CUSTOM_TEST_NAMES = %w[tom roger titi james foo bar baz julio alice bob]
RANDOM_CUSTOM_TEST_NAMES_SIZE = RANDOM_CUSTOM_TEST_NAMES.size 

class NameEngine
  def ask_player_choice(player_number)
    # little trick with 'player_number' to simulate the empty choice
    player_number == :empty_choice ? '' : RANDOM_CUSTOM_TEST_NAMES.sample
  end
end

class NameEngineTest < Minitest::Test
  RANDOM_TEST_NAMES = %w[alex bert iris ann lolo evan mike larry moe]
  RANDOM_NAMES_LIST_SIZE = RANDOM_TEST_NAMES.size

  def setup
    @name_engine = NameEngine.new(RANDOM_TEST_NAMES)
  end

  def test_it_responds_to_choose_player_name_method
    assert_respond_to(@name_engine, :choose_player_name)
  end

  def test_it_responds_to_pick_random_name_method
    assert_respond_to(@name_engine, :pick_random_name)
  end

  def test_it_can_choose_custom_player_name
    result = @name_engine.choose_player_name(:test_engine_select_a_custom_name)
    assert_includes RANDOM_CUSTOM_TEST_NAMES, result
  end

  def test_it_can_choose_random_name
    result = @name_engine.choose_player_name(:empty_choice)
    assert_includes RANDOM_TEST_NAMES, result
  end
end
