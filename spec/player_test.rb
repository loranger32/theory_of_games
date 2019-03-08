require_relative 'spec_helpers'
require_relative '../lib/game_theory/player_class'

class PlayerAttributesTest < Minitest::Test
  def setup
    @score_recorder = Minitest::Mock.new
    @behavior = Minitest::Mock.new
    @player = Player.new(score_recorder: @score_recorder, name: 'Test Player', behavior: @behavior)
  end

  def test_player_has_a_name_reader_accessor
    assert_equal 'Test Player', @player.name
  end

  def test_player_has_a_behavior_reader_accessor
    assert_equal @behavior.object_id, @player.behavior.object_id
  end

  def test_player_has_a_score_recorder_accessor
    assert_equal @score_recorder.object_id, @player.score_recorder.object_id
  end

  def test_player_has_a_move_global_accessor
    assert_silent { @player.move = :random }
    assert_equal :random, @player.move
  end

  def test_player_has_a_move_attribute_set_to_nil_by_default
    assert_nil @player.move
  end

  def test_it_has_a_string_representation
    ['Test Player', 'Comportement', 'Nom'].each do |target|
      assert_includes @player.to_s, target
    end
  end

  def test_it_can_display_itself
    out, err = capture_io do
      @player.display
    end

    ['Test Player', 'Comportement', 'Nom'].each do |target|
      assert_includes out, target
    end
  end
end

class PlayerMovesTest < Minitest::Test
  def setup
    @score_recorder = Minitest::Mock.new
    @behavior = Minitest::Mock.new
    @player = Player.new(name: 'Test Player', score_recorder: @score_recorder,
                         behavior: @behavior)
    @behavior.expect(:choose_move, :cooperates, [@player])
  end

  def test_it_can_play_a_move
    @player.play_move
    assert_equal :cooperates, @player.move
    @behavior.verify
  end

  def test_it_says_if_player_cooperates
    @player.move = :cooperates
    assert @player.cooperates?
    @player.move = :betrays
    refute @player.cooperates?
  end

  def test_it_says_if_player_betrays
    @player.move = :cooperates
    refute @player.betrays?
    @player.move = :betrays
    assert @player.betrays?
  end

  def test_it_can_reset_her_move
    @player.move = :betrays
    assert_equal :betrays, @player.move
    @player.reset_move
    assert_nil @player.move
  end

  def test_it_can_display_move_correctly
    @player.move = :cooperates
    assert_equal 'coopère', @player.display_move

    @player.move = :betrays
    assert_equal 'trahit', @player.display_move

    @player.move = :invalid_move
    assert_equal 'action inconnue', @player.display_move
  end
end

class PlayerScoreTest < Minitest::Test
  def setup
    @score_recorder = Minitest::Mock.new
    @behavior = Minitest::Mock.new
    @player = Player.new(name: 'Test Player', score_recorder: @score_recorder,
                         behavior: @behavior)
  end

  def test_player_can_return_total_score
    @score_recorder.expect(:total, 5)
    assert_equal 5, @player.score
    @score_recorder.verify
  end

  def test_player_can_return_turn_earning
    @score_recorder.expect(:turn_earning, 3)
    assert_equal 3, @player.turn_earning
    @score_recorder.verify
  end

  def test_player_can_earn_max
    @score_recorder.expect(:earn_max, nil)
    @player.earn_max
    @score_recorder.verify
  end

  def test_player_can_earn_min
    @score_recorder.expect(:earn_min, nil)
    @player.earn_min
    @score_recorder.verify
  end

  def test_player_can_earn_medium
    @score_recorder.expect(:earn_medium, nil)
    @player.earn_medium
    @score_recorder.verify
  end

  def test_player_score_can_be_reset_to_zero
    @score_recorder.expect(:reset!, nil)
    @player.reset_score
    @score_recorder.verify
  end

  def test_player_can_reset_turn_earning
    @score_recorder.expect(:reset_turn_earning!, nil)
    @player.reset_turn_earning
    @score_recorder.verify
  end
end
