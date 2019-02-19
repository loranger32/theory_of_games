require_relative 'spec_helpers'
require_relative '../lib/game_theory/reporter_class'

class ReporterTest < Minitest::Test
  def setup
    @reporter = Reporter.new
    @player1 = Minitest::Mock.new
    @player2 = Minitest::Mock.new
    @players = [@player1, @player2]
  end

  def test_it_has_an_attribute_set_to_nil_on_initialisation
    assert_nil @reporter.send(:players)
  end

  def test_it_can_assign_players
    @reporter.assign_players(@players)
    assert_equal @players, @reporter.send(:players)
  end

  def test_it_responds_to_display_game_report_method
    assert_respond_to(@reporter, :display_game_report)
  end
end
