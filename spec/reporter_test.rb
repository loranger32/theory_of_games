require_relative 'spec_helpers'
require_relative '../lib/game_theory/displayable_module'
require_relative '../lib/game_theory/validable_module'
require_relative '../lib/game_theory/reporter_class'

class ReporterTest < Minitest::Test
  def setup
    @reporter = Reporter.new
    @player1 = Minitest::Mock.new
    @player2 = Minitest::Mock.new
    @players = [@player1, @player2]
  end

  def test_it_has_a_player_attribute_set_to_nil_on_initialisation
    assert_nil @reporter.send(:players)
  end

  def test_it_can_assign_players
    @reporter.assign_players(@players)
    assert_equal @players, @reporter.send(:players)
  end

  def test_it_responds_to_display_report_method
    assert_respond_to(@reporter, :display_report)
  end

  def test_it_can_set_the_report_form_to_long
    @reporter.input = StringIO.new('t')
    capture_io do
      @reporter.define_form_report
    end
    assert_equal :long, @reporter.send(:report_form)
  end

  def test_it_can_set_the_report_form_to_short
    @reporter.input = StringIO.new('r')
    capture_io do
      @reporter.define_form_report
    end
    assert_equal :short, @reporter.send(:report_form)
  end

  def test_it_set_the_short_report_form_by_default
    assert_equal :short, @reporter.send(:report_form)
  end
end
