require 'pry'
require_relative 'spec_helpers'
require_relative '../lib/game_theory/displayable_module'
require_relative '../lib/game_theory/behavior_engine_class'

class BehaviorEngineTest < Minitest::Test
  # Constant copied from the game_theory.rb file
  BEHAVIORS = { 'n' => :naive, 't' => :traitor, 'h' => :random,
              'r' => :quick_adapter, 's' => :slow_adapter }

  def setup
    @behavior_engine = BehaviorEngine.new(BEHAVIORS)
  end

  def test_it_responds_to_coose_behavior_method
    assert_respond_to(@behavior_engine, :choose_player_behavior)
  end

  def test_it_chooses_correctly_player_behavior
    BEHAVIORS.keys.each do |choice|
      @behavior_engine.input = StringIO.new(choice)
      capture_io do
        behavior = @behavior_engine.choose_player_behavior
        assert_equal BEHAVIORS[choice], behavior
      end
    end
  end
end
