require_relative 'spec_helpers'
require_relative '../lib/game_theory/player_class'

class PlayerAttributesTest < Minitest::Test
  def setup
    @score = Minitest::Mock.new
    @player = Player.new(@score, name: 'Test Player', behavior: :random)
  end

  def test_player_has_a_name
    assert_equal 'Test Player', @player.name
  end

  def test_player_has_a_behavior
    assert_equal :random, @player.behavior
  end

  def test_player_respond_to_score_instance_method
    assert_respond_to(@player, :score)
  end

  def test_player_score_method_works_ok
    @score.expect(:total, 4)
    assert_equal 4, @player.score
    @score.verify
  end

  def test_player_has_a_move_attribute_set_to_nil_by_default
    assert_nil @player.move
  end
end

class PlayerMovesTest < Minitest::Test
  def setup
    @gg_score = Minitest::Mock.new
    @bg_score = Minitest::Mock.new
    @rg_score = Minitest::Mock.new
    @good_guy = Player.new(@gg_score, name: 'Test Good Guy', behavior: :naive)
    @bad_guy = Player.new(@bg_score, name: 'Test Bad Guy', behavior: :traitor)
    @random_guy = Player.new(@rg_score, name: 'Test Random Guy',
                             behavior: :random)
    @players = [@good_guy, @bad_guy, @random_guy]
  end

  def test_player_cooperates_method
    @players.each(&:play_move)
    assert @good_guy.cooperates?
    refute @bad_guy.cooperates?
  end

  def test_player_betrays_method
    @players.each(&:play_move)
    assert @bad_guy.betrays?
    refute @good_guy.betrays?
  end

  def test_player_store_correct_move_when_she_plays
    @players.map(&:play_move)
    assert_equal :cooperates, @good_guy.move
    assert_equal :betrays, @bad_guy.move
    assert_includes %I[betrays cooperates], @random_guy.move
  end

  def test_player_move_can_be_reset_to_nil
    assert_nil @good_guy.move
    @good_guy.play_move
    refute_nil @good_guy.move
    @good_guy.reset_move
    assert_nil @good_guy.move
  end
end

class PlayerScoreTest < Minitest::Test
  def setup
    @score = Minitest::Mock.new
    @player = Player.new(@score, name: 'Test Player', behavior: :cooperator)
  end

  def test_player_can_earn_max
    @score.expect(:earn_max, nil)
    @player.earn_max
    @score.verify
  end

  def test_player_can_earn_medium
    @score.expect(:earn_medium, nil)
    @player.earn_medium
    @score.verify
  end

  def test_player_can_earn_min
    @score.expect(:earn_min, nil)
    @player.earn_min
    @score.verify
  end

  def test_player_score_can_be_reset_to_zero
    @score.expect(:reset!, nil)
    @player.reset_score
    @score.verify
  end

  def test_player_reset_turn_earning
    @score.expect(:reset_turn_earning!, nil)
    @player.reset_turn_earning
    @score.verify
  end

  def test_to_s_method
    assert_instance_of(String, @player.to_s)
  end

  def test_display
    out, err = capture_io do
      @player.display
    end

    assert_includes(out, 'Test Player')
  end
end
