require_relative 'spec_helpers'
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

  def test_it_chooses_correctly_player_behavior_with_a_string_argument
    behavior_classes = BehaviorFactory::BEHAVIOR_CLASSES
    behaviors = BehaviorFactory::BEHAVIORS

    behaviors.keys.each do |choice|
      behavior = @behavior_factory.create_behavior(choice)
      expected_class = behavior_classes[behaviors[choice]]
      assert_instance_of expected_class, behavior
    end
  end

  def test_it_chooses_correctly_player_behavior_with_a_sym_argument
    behavior_classes = BehaviorFactory::BEHAVIOR_CLASSES
    behaviors = BehaviorFactory::BEHAVIORS

    behaviors.values.each do |choice|
      behavior = @behavior_factory.create_behavior(choice)
      expected_class = behavior_classes[choice]
      assert_instance_of expected_class, behavior
    end
  end

  def test_create_behavior_raise_error_with_invalid_argument
    assert_raises(BehaviorArgumentError) do
      @behavior_factory.create_behavior(42)
    end

    assert_raises(BehaviorArgumentError) do
      @behavior_factory.create_behavior([:traitor])
    end

    assert_raises(BehaviorArgumentError) do
      @behavior_factory.create_behavior(traitor: true)
    end
  end

  def test_create_behavior_raises_error_with_unknwown_value_as_argument
    assert_raises(BehaviorArgumentError) do
      @behavior_factory.create_behavior('invalid')
    end

    assert_raises(BehaviorArgumentError) do
      @behavior_factory.create_behavior(:invalid)
    end
  end
end
