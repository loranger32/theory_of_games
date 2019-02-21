require_relative 'spec_helpers'
require_relative '../lib/game_theory/displayable_module'
require_relative '../lib/game_theory/behavior_engine_class'

# Constant copied from the game_theory.rb file
BEHAVIORS = { 'n' => :naive, 't' => :traitor, 'h' => :random,
              'r' => :quick_adapter, 's' => :slow_adapter }

class BehaviorEngine
  def ask_behavior_to_player
    BEHAVIORS.keys.sample
  end
end

class BehaviorEngineTest < Minitest::Test
  def setup
    @behavior_engine = BehaviorEngine.new(BEHAVIORS)
  end

  def test_it_responds_to_coose_behavior_method
    assert_respond_to(@behavior_engine, :choose_player_behavior)
  end

  def test_it_chooses_player_behavior
    behavior = @behavior_engine.choose_player_behavior
    assert_includes BEHAVIORS.values, behavior
  end
end
