require_relative 'spec_helpers'
require_relative '../lib/game_theory/displayable_module'
require_relative '../lib/game_theory/validable_module'
require_bahavior_classes
require_relative '../lib/game_theory/behavior_factory_class'

class BehaviorFactoryTest < Minitest::Test
  def setup
    @history = Minitest::Mock.new
    @behavior_factory = BehaviorFactory.new(@history)
  end

  def test_it_has_a_history_reader_attribute
    assert_equal @history.object_id, @behavior_factory.history.object_id
  end

  def test_it_responds_to_coose_behavior_method
    assert_respond_to(@behavior_factory, :create_behavior)
  end

  def test_it_chooses_correctly_player_behavior
    behavior_classes = BehaviorFactory::BEHAVIOR_CLASSES
    behaviors = BehaviorFactory::BEHAVIORS

    BehaviorFactory::BEHAVIORS.keys.each do |choice|
      @behavior_factory.input = StringIO.new(choice)
      capture_io do
        behavior = @behavior_factory.create_behavior
        expected_class = behavior_classes[behaviors[choice]]
        assert_instance_of expected_class, behavior
      end
    end
  end
end
