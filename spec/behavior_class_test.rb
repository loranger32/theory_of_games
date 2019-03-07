require_relative 'spec_helpers'
require_relative '../lib/game_theory/behavior_class'

class BehaviorClassMethodsTest < Minitest::Test
  def test_behaviors_class_methods
    assert_equal Behavior::BEHAVIORS, Behavior.behaviors
  end

  def test_valid_behaviors_choice
    assert_equal Behavior::BEHAVIORS.keys, Behavior.valid_behavior_choices
  end
end

class BehaviorInitializationTest < Minitest::Test
  def test_it_raises_an_error_with_invalid_type_argument
    history = Minitest::Mock.new
    history.expect(:store_turn, nil)
    assert_raises(BehaviorArgumentError) do
      Behavior.new(type: 'hello', history: history)
    end
  end

  def test_it_raises_an_error_with_invalid_history_argument
    assert_raises(BehaviorArgumentError) do
      Behavior.new(type: :random, history: 'history')
    end
  end
end

class BehaviorTest < Minitest::Test
  def setup
    @history = Minitest::Mock.new
    @history.expect(:store_turn, nil)
    @player = Minitest::Mock.new
  end

  def test_it_cooperates_when_naive
    behavior = Behavior.new(type: :naive, history: @history)
    assert_equal :cooperates, behavior.choose_move(@player)
  end

  def test_it_bertrays_when_traitor
    behavior = Behavior.new(type: :traitor, history: @history)
    assert_equal :betrays, behavior.choose_move(@player)
  end

  def test_it_picks_at_random_when_random
    behavior = Behavior.new(type: :random, history: @history)

    10.times do
      assert_includes %I[cooperates betrays], behavior.choose_move(@player)
    end
  end

  def test_it_returns_the_correct_translation
    behaviors = Behavior::BEHAVIORS.values.each_with_object([]) do |type, list|
      list << Behavior.new(type: type, history: @history)
    end

    behaviors.each do |behavior|
      assert_equal Behavior::TRANSLATIONS[behavior.type], behavior.to_s
    end
  end
end
