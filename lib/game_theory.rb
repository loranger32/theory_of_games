#!/usr/bin/env ruby

######### Gems and Standard Library compenents loading

require 'bundler'
require 'bundler/setup'
require 'yaml'
Bundler.require(:default, :development)

######### CLI ui components

require_relative 'game_theory/cli_ui/messages_module'
require_relative 'game_theory/cli_ui/displayable_module'
require_relative 'game_theory/cli_ui/validable_module'
require_relative 'game_theory/cli_ui/tableable_module'

######### Game logic files

require_relative 'game_theory/history_class'
require_relative 'game_theory/turn_record_class'
require_relative 'game_theory/score_class'
require_relative 'game_theory/name_factory_class'

# Require first the abstract Behavior class
require_relative 'game_theory/behaviors/behavior_class'

# Then the concrete subclasses
require_relative 'game_theory/behaviors/naive_class'
require_relative 'game_theory/behaviors/pick_random_class'
require_relative 'game_theory/behaviors/traitor_class'
require_relative 'game_theory/behaviors/slow_adapter_class'
require_relative 'game_theory/behaviors/quick_adapter_class'

require_relative 'game_theory/behavior_factory_class'
require_relative 'game_theory/player_class'
require_relative 'game_theory/player_factory_class'
require_relative 'game_theory/earning_engine_class'
require_relative 'game_theory/logic_engine_class'
require_relative 'game_theory/turn_engine_class'
require_relative 'game_theory/reporter_class'


# Main loop class 
require_relative 'game_theory/cli_ui/cli_main_loop_class'


# CLI game loop class
require_relative 'game_theory/cli_ui/cli_game_loop_class'


# Constants

VERSION = '0.0.2'

######### Objects generations

# Generate the history object - shared by all players
history = History.new


# Generate the name engine instance
random_names = YAML.load_file('./data/random_names.yaml')
name_factory = NameFactory.new(random_names)

behavior_factory = BehaviorFactory.new(history)


# Generate the player factory instance
player_factory = PlayerFactory.new(Player, Score, Behavior)


# Rules for granting earnings
earning_engine = EarningEngine.new


# Game logic - needs acces to the earning engine to grant earnings
logic_engine = LogicEngine.new(earning_engine)


# Engine that process turns - needs the logic engine, the history object and
# the TurnRecord class
turn_engine = TurnEngine.new(logic_engine, history, TurnRecord)


# Engine that generates the reports
reporter = Reporter.new


# Interactive Game loop can be instantiated with the turn engine, the reporter
# and the player factory
cli_game_loop = CliGameLoop.new(turn_engine, reporter, player_factory,
                                name_factory, behavior_factory)

# Main game loop is instantiated with the two different game loop (interactive
# and quick one - this last is not yet implemented)
CliMainLoop.new(cli_game_loop).run


# Fancy ending message
at_exit do
  Messages.exit_game
end
