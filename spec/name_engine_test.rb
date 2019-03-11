require_relative 'spec_helpers'
require_relative '../lib/game_theory/name_engine_class'

class NameEngineTest < Minitest::Test
  RANDOM_TEST_NAMES = %w[alex ann bert bob evan iris larry lolo mike moe].freeze

  def setup
    @name_engine = NameEngine.new(RANDOM_TEST_NAMES)
  end

  def test_it_responds_to_create_name_method
    assert_respond_to(@name_engine, :create_name)
  end

  def test_it_raises_an_error_if_argument_is_not_nil_or_string
    assert_raises(InvalidNameArgumentError) { @name_engine.create_name(:name) }
    assert_raises(InvalidNameArgumentError) { @name_engine.create_name(['jo']) }
    assert_raises(InvalidNameArgumentError) { @name_engine.create_name(1234) }
  end

  def test_it_creates_and_stores_a_random_unique_name_without_arguments
    1.upto(5) do |counter|
      result = @name_engine.create_name
      assert_includes RANDOM_TEST_NAMES, result
      assert_includes @name_engine.choosen_names, result
      assert_equal counter, @name_engine.choosen_names.size
    end
  end

  def test_it_creates_and_stores_a_random_unique_name_with_empty_string
    1.upto(5) do |counter|
      result = @name_engine.create_name('')
      assert_includes RANDOM_TEST_NAMES, result
      assert_includes @name_engine.choosen_names, result
      assert_equal counter, @name_engine.choosen_names.size
    end
  end

  def test_it_creates_and_stores_a_valid_unique_name_with_valid_name_argument
    valid_names = %w[pierre paul jacques antoine richard]

    valid_names.each_with_index do |name, index|
      result = @name_engine.create_name(name)
      assert_equal name, result
      assert_includes @name_engine.choosen_names, name
      assert_equal index + 1, @name_engine.choosen_names.size
    end
  end

  def test_it_reports_the_choice_of_an_existent_name
    @name_engine.create_name('roger')
    assert_equal :existent_name, @name_engine.create_name('roger')
  end

  def test_it_reports_the_choice_of_an_invalid_name
    assert_equal :invalid_name, @name_engine.create_name('$*£ù')
  end

  def test_it_can_reset_choosen_names
    %w[riri fifi loulou].each { |name| @name_engine.create_name(name) }
    assert_equal 3, @name_engine.choosen_names.size
    @name_engine.reset_names!
    assert_instance_of Array, @name_engine.choosen_names
    assert_empty @name_engine.choosen_names
  end
end
