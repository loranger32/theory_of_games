require_relative 'spec_helpers'
require_bahavior_classes


class AbstractBehaviorTest < Minitest::Test
  def setup
    @history           = Minitest::Mock.new
    @player            = Minitest::Mock.new
    @abstract_behavior = Behavior.new(@history)
  end

  def it_has_a_history_reader_accessor
    assert_equal @history, @abstract_behavior.history
  end

  def it_has_a_type_reader_accessor
    assert_equal :abstract_behavior_class, @abstract_behavior.type
  end

  def test_choose_move_raises_error_on_abstract_class
    assert_raises(AbstractBehaviorClassError) do
      @abstract_behavior.choose_move(@player)
    end
  end

  def test_to_s_raises_error_on_abstract_class
    assert_raises(AbstractBehaviorClassError) { @abstract_behavior.to_s }
  end

  def test_private_method_postinitialize_returns_nil_on_abstract_class
    assert_equal :abstract_behavior_class, @abstract_behavior.send(:post_initialize)
  end
end

module Behaviorable
  def test_it_has_a_history_reader_attribute
    assert_equal @history.object_id, @behavior.history.object_id
  end

  def test_respond_to_to_s
    assert_respond_to(@behavior, :to_s)
  end

  def test_to_s_is_implemented
    assert_instance_of String, @behavior.to_s
  end

  def test_respond_to_choose_move
    assert_respond_to(@behavior, :choose_move)
  end

  def test_choose_move_is_implemented
    # required to allow history to respond to two methods for the two adapters
    @history.expect(:empty?, true)
    @history.expect(:less_than_three_turns?, true)
    assert_silent { @behavior.choose_move(@player) }
    # No verification needed, verification will be done in the concrete class
  end

  def test_respond_to_postinitialize
    assert_respond_to(@behavior, :post_initialize)
  end

  def test_post_initialize_is_implemented
    assert_silent { @behavior.send(:post_initialize) }
  end
end

class NaiveBehaviorTest < Minitest::Test
  include Behaviorable

  def setup
    @history  = Minitest::Mock.new
    @player   = Minitest::Mock.new
    @behavior = Naive.new(@history)
  end

  def test_choose_move
    assert_equal :cooperates, @behavior.choose_move(@player)
  end

  def test_it_has_a_distinctive_type_attribute
    assert_equal :naive, @behavior.type
  end

  def test_to_s_returns_the_correct_value
    assert_equal 'coopère', @behavior.to_s
  end
end

class TraitorBehaviorTest < Minitest::Test
  include Behaviorable

  def setup
    @history  = Minitest::Mock.new
    @player   = Minitest::Mock.new
    @behavior = Traitor.new(@history)
  end

  def test_choose_move
    assert_equal :betrays, @behavior.choose_move(@player)
  end

  def test_it_has_a_distinctive_type_attribute
    assert_equal :traitor, @behavior.type
  end

  def test_to_s_returns_the_correct_value
    assert_equal 'trahit', @behavior.to_s
  end
end

class PickRandomBehaviorTest < Minitest::Test
  include Behaviorable

  def setup
    @player   = Minitest::Mock.new
    @history  = Minitest::Mock.new
    @behavior = PickRandom.new(@history)
  end

  def test_choose_move
    10.times do 
      assert_includes %I[cooperates betrays], @behavior.choose_move(@player)
    end
  end

  def test_it_has_a_distinctive_type_attribute
    assert_equal :random, @behavior.type
  end

  def test_to_s_returns_the_correct_value
    assert_equal 'au hasard', @behavior.to_s
  end
end

class QuickAdapterBehaviorTest < Minitest::Test
  include Behaviorable

  def setup
    @history  = Minitest::Mock.new
    @player   = Minitest::Mock.new
    @behavior = QuickAdapter.new(@history)
  end

  def test_choose_cooperate_mode_when_history_is_empty
    @history.expect(:empty?, true)
    assert_equal :cooperates, @behavior.choose_move(@player)
    @history.verify
  end

  def test_choose_cooperate_mode_when_no_traitor_on_last_turn
    @history.expect(:empty?, false)
    @history.expect(:traitor_on_last_turn?, false, [@player])
    assert_equal :cooperates, @behavior.choose_move(@player)
    @history.verify
  end

  def test_choose_betray_mode_when_traitor_on_last_run
    @history.expect(:empty?, false)
    @history.expect(:traitor_on_last_turn?, true, [@player])
    assert_equal :betrays, @behavior.choose_move(@player)
    @history.verify
  end

  def test_it_has_a_distinctive_type_attribute
    assert_equal :quick_adapter, @behavior.type
  end

  def test_to_s_returns_the_correct_value
    assert_equal 'adapte rapidement', @behavior.to_s
  end
end

class SlowAdapterBehaviorTest < Minitest::Test
  include Behaviorable

  def setup
    @history  = Minitest::Mock.new
    @player   = Minitest::Mock.new
    @behavior = SlowAdapter.new(@history)
  end

  def test_choose_cooperate_mode_when_history_has_less_than_three_turns
    @history.expect(:less_than_three_turns?, true)
    assert_equal :cooperates, @behavior.choose_move(@player)
    @history.verify
  end

  def test_choose_betray_mode_when_traitor_on_last_three_turns
    @history.expect(:less_than_three_turns?, false)
    @history.expect(:traitor_on_last_three_turns?, true, [@player])
    assert_equal :betrays, @behavior.choose_move(@player)
    @history.verify
  end

  def test_choose_cooperate_mode_when_naive_on_last_three_turns
    @history.expect(:less_than_three_turns?, false)
    @history.expect(:traitor_on_last_three_turns?, false, [@player])
    @history.expect(:naive_on_last_three_turns?, true, [@player])
    assert_equal :cooperates, @behavior.choose_move(@player)
    @history.verify
  end

  def test_pick_last_turn_move_if_undecided
    @history.expect(:less_than_three_turns?, false)
    @history.expect(:traitor_on_last_three_turns?, false, [@player])
    @history.expect(:naive_on_last_three_turns?, false, [@player])
    @history.expect(:pick_last_move_of_player, :cooperates, [@player])
    assert_equal :cooperates, @behavior.choose_move(@player)
    @history.verify
  end

  def test_it_has_a_distinctive_type_attribute
    assert_equal :slow_adapter, @behavior.type
  end

  def test_to_s_returns_the_correct_value
    assert_equal 'adapte lentement', @behavior.to_s
  end
end
