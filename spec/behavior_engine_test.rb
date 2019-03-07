require_relative 'spec_helpers'
require_relative '../lib/game_theory/displayable_module'
require_relative '../lib/game_theory/validable_module'
require_relative '../lib/game_theory/behavior_engine_class'

class BehaviorEngineTest < Minitest::Test
  BEHAVIORS = { 'n' => :naive, 't' => :traitor, 'h' => :random,
                'r' => :quick_adapter, 's' => :slow_adapter }.freeze
  def setup
    @behavior_class = Minitest::Mock.new
    @behavior_class.expect(:[], nil)
    @behavior_class.expect(:behaviors, BEHAVIORS)
    @behavior_class.expect(:valid_behavior_choices, BEHAVIORS.keys)
    @history = Minitest::Mock.new

    BEHAVIORS.values.size.times do |behavior|
      @behavior_class.expect(:new, Minitest::Mock.new,
                             [{ type: behavior, history: @history }])
    end

    @behavior_engine = BehaviorEngine.new(@behavior_class, @history)
  end

  def test_it_responds_to_coose_behavior_method
    skip
    assert_respond_to(@behavior_engine, :choose_player_behavior)
  end

  def test_it_chooses_correctly_player_behavior
    skip
    BEHAVIORS.keys.each do |choice|
      @behavior_engine.input = StringIO.new(choice)
      capture_io do
        behavior = @behavior_engine.choose_player_behavior
        assert_is_a? Minitest::Mock, behavior
      end
    end
  end
end
