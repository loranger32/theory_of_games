require_relative 'spec_helpers'
require_relative '../lib/game_theory/turn_class'

class TurnTest < Minitest::Test
  def setup
    @behavior = Minitest::Mock.new
    @turn = Turn.new(name: 'Test Player', move: :cooperates,
                     display_move: 'coopère', earning: 3, behavior: @behavior, score: 20)
  end

  def test_it_has_a_name_reader_accessor
    assert_equal 'Test Player', @turn.name
  end

  def test_it_has_a_move_reader_accessor
    assert_equal :cooperates, @turn.move
  end

  def test_it_has_a_display_move_reader_accessor
    assert_equal 'coopère', @turn.display_move
  end

  def test_it_has_a_earning_reader_accessor
    assert_equal 3, @turn.earning
  end

  def test_it_has_a_behavior_reader_accessor
    assert_equal @behavior.object_id, @turn.behavior.object_id
  end

  def test_it_has_a_score_reader_accessor
    assert_equal 20, @turn.score
  end

  def test_it_says_if_a_turn_has_a_naive
    assert @turn.a_naive?
  end

  def test_it_says_if_a_trun_has_a_traitor
    refute @turn.a_traitor?
  end
end
