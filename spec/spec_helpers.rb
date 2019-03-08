require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
require 'pry'

def require_bahavior_classes
  require_relative '../lib/game_theory/behaviors/behavior_class'
  require_relative '../lib/game_theory/behaviors/naive_class'
  require_relative '../lib/game_theory/behaviors/traitor_class'
  require_relative '../lib/game_theory/behaviors/pick_random_class'
  require_relative '../lib/game_theory/behaviors/quick_adapter_class'
  require_relative '../lib/game_theory/behaviors/slow_adapter_class'
end
