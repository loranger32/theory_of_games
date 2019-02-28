require_relative 'spec_helpers'
require_relative '../lib/game_theory/score_class'

class ScoreTest < Minitest::Test
  def setup
    @score = Score.new
  end

  def test_it_has_a_total_attribute_reader
    assert_respond_to(@score, :total)
  end

  def test_it_has_a_total_attribute_initialized_to_zero
    assert_equal 0, @score.total
  end

  def test_it_has_a_turn_earning_attribute_reader
    assert_respond_to(@score, :turn_earning)
  end

  def test_it_has_a_turn_earning_attribute_initialized_to_zero
    assert_equal 0, @score.turn_earning
  end

  def test_it_can_earn_a_minimum_value
    @score.earn_min
    assert_equal Score::MIN_GAIN, @score.total
    assert_equal Score::MIN_GAIN, @score.turn_earning
  end

  def test_it_can_earn_a_maximum_value
    @score.earn_max
    assert_equal Score::MAX_GAIN, @score.total
    assert_equal Score::MAX_GAIN, @score.turn_earning
  end

  def test_it_can_earn_a_medium_value
    @score.earn_medium
    assert_equal Score::MEDIUM_GAIN, @score.total
    assert_equal Score::MEDIUM_GAIN, @score.turn_earning
  end

  def test_it_can_accumulate_points
    expected_total = Score::MIN_GAIN + Score::MEDIUM_GAIN + Score::MAX_GAIN
    @score.earn_min
    @score.earn_medium
    @score.earn_max
    assert_equal expected_total, @score.total
  end

  def test_accumulated_points_do_not_interfere_with_turn_earnings
    @score.earn_min
    @score.earn_medium
    @score.earn_max
    assert_equal Score::MAX_GAIN, @score.turn_earning
  end

  def test_total_score_can_be_reset_to_zero
    @score.earn_min
    @score.earn_medium
    @score.earn_max
    assert @score.total > 0
    @score.reset!
    assert_equal 0, @score.total
  end

  def test_turn_earning_can_be_reset_to_zero
    @score.earn_max
    @score.reset_turn_earning!
    assert_equal 0, @score.turn_earning
  end
end
