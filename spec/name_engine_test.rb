require 'pry'
require_relative 'spec_helpers'
require_relative '../lib/game_theory/displayable_module'
require_relative '../lib/game_theory/validable_module'
require_relative '../lib/game_theory/name_engine_class'

class NameEngineTest < Minitest::Test
  RANDOM_TEST_NAMES = %w[alex bert iris ann lolo evan mike larry moe]

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
    @name_engine.input = StringIO.new("Roger")
    capture_io do
      result = @name_engine.choose_player_name(1)
      assert_equal "Roger", result
    end
  end

  def test_it_can_choose_random_name
    @name_engine.input = StringIO.new('')
    #capture_io do
      result = @name_engine.choose_player_name(1)
      assert_includes RANDOM_TEST_NAMES, result
    #end
  end
end
