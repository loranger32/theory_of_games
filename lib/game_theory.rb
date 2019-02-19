#!/usr/bin/env ruby

require 'bundler'
require 'bundler/setup'
Bundler.require(:default, :development)

require_relative 'game_theory/messages_module'
require_relative 'game_theory/displayable_module'
require_relative 'game_theory/score_class'
require_relative 'game_theory/game_loop_class'
require_relative 'game_theory/player_class'
require_relative 'game_theory/player_factory_class'
require_relative 'game_theory/earning_engine_class'
require_relative 'game_theory/two_player_logic_class'
require_relative 'game_theory/turn_engine_class'
require_relative 'game_theory/reporter_class'

# Generate Players - Will take options in the future
player_factory = PlayerFactory.new(Player, Score)

# Rules for granting earnings - acts on players instances
earning_engine = EarningEngine.new

# Game logic - needs acces to the earning engine to grant earnings
logic_engine = TwoPlayerLogic.new(earning_engine)

# Engine that process turns - needs the logic engine to know how
turn_engine = TurnEngine.new(logic_engine)

# Engine that generates the reports
reporter = Reporter.new

# Game can be instantiated with the turn engine
GameLoop.new(turn_engine, reporter, player_factory).run

at_exit do
  Messages.exit_game
end
