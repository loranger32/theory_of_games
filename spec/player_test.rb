require_relative 'spec_helpers'
require_relative '../lib/game_theory/player_class'

class PlayerAttributesTest < Minitest::Test
  def setup
    @player = Player.new(name: 'Test Player', behavior: :random)
  end

  def test_player_has_a_name
    assert_equal 'Test Player', @player.name
  end

  def test_player_has_a_behavior
    assert_equal :random, @player.behavior
  end

  def test_player_has_a_score_attribute_set_to_zero_by_default
    assert_equal 0, @player.score
  end

  def test_player_has_a_move_attribute_set_to_nil_by_default
    assert_nil @player.move
  end
end

class PlayerMovesTest < Minitest::Test
  def setup
    @good_guy = Player.new(name: 'Test Good Guy', behavior: :cooperator)
    @bad_guy = Player.new(name: 'Test Bad Guy', behavior: :traitor)
    @random_guy = Player.new(name: 'Test Random Guy', behavior: :random)
    @players = [@good_guy, @bad_guy, @random_guy]
  end

  def test_player_can_play_a_move
    @players.all? { |player| assert_silent { player.move } }
  end

  def test_player_store_correct_move_when_she_plays
    @players.map(&:play_move)
    assert_equal :cooperates, @good_guy.move
    assert_equal :betrays, @bad_guy.move
    assert_includes [:betrays, :cooperates], @good_guy.move
  end

  def test_player_move_cvan_be_reset_to_nil
    assert_nil @good_guy.move
    @good_guy.play_move
    refute_nil @good_guy.move
    @good_guy.reset_move
    assert_nil @good_guy.move
  end
end

class PlayerScoreTest < Minitest::Test
  def setup
    @player = Player.new(name: 'Test Player', behavior: :cooperator)
    @max_gain = Player::MAX_GAIN
    @medium_gain = Player::MEDIUM_GAIN
    @min_gain = Player::MIN_GAIN
  end

  def check_score_is_zero
    assert_equal 0, @player.score
  end

  def test_player_can_earn_max
    check_score_is_zero
    @player.earn_max
    assert_equal @max_gain, @player.score
  end

  def test_player_can_earn_medium
    check_score_is_zero
    @player.earn_medium
    assert_equal @medium_gain, @player.score
  end

  def test_player_can_earn_min
    
    check_score_is_zero
    @player.earn_min
    assert_equal @min_gain, @player.score
  end

  def test_player_score_keeps_track_of_all_results
    total = @max_gain + @max_gain + @min_gain + @medium_gain + @medium_gain
    2.times { @player.earn_max }
    @player.earn_min
    2.times { @player.earn_medium }

    assert_equal total, @player.score
  end

  def test_player_score_can_be_reset_to_zero
    check_score_is_zero
    @player.earn_min
    @player.earn_medium
    @player.earn_max
    assert @player.score > 0
    @player.reset_score
    check_score_is_zero
  end
end
