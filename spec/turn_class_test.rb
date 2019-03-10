require_relative 'spec_helpers'
require_relative '../lib/game_theory/turn_class'

class TurnTest < Minitest::Test
  def setup
    @behavior = Minitest::Mock.new
    @turn = Turn.new(name: 'Test Player', move: :cooperates,
                     display_move: 'coopère', earning: 3, behavior: @behavior, score: 20)
  end

  def create_mock_player_one
    @behavior1 = Minitest::Mock.new
    @score1    = Minitest::Mock.new
    @player1   = Minitest::Mock.new
    @player1.expect(:name, 'Test Player One')  
    @player1.expect(:move, :betrays)  
    @player1.expect(:display_move, 'trahit')  
    @player1.expect(:turn_earning, 5)  
    @player1.expect(:behavior, @behavior1)  
    @player1.expect(:score, @score1)  
  end

  def create_mock_player_two
    @behavior2 = Minitest::Mock.new
    @score2    = Minitest::Mock.new
    @player2   = Minitest::Mock.new
    @player2.expect(:name, 'Test Player Two')  
    @player2.expect(:move, :cooperates)  
    @player2.expect(:display_move, 'coopère')  
    @player2.expect(:turn_earning, 0)  
    @player2.expect(:behavior, @behavior2)  
    @player2.expect(:score, @score2)  

  end

  def test_it_can_create_turns
    create_mock_player_one
    create_mock_player_two
    turn = Turn.create_turn([@player1, @player2])

    assert_instance_of(Array, turn)
    assert_equal 2, turn.size
    assert_instance_of(Turn, turn.first)
    assert_instance_of(Turn, turn.last)
    assert_equal 'Test Player One', turn.first.name
    assert_equal 'Test Player Two', turn.last.name
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
