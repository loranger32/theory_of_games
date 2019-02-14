#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
require 'bundler/setup'
Bundler.require(:default, :development)

require_relative 'game_theory/game_loop_class'
require_relative 'game_theory/player_class'
require_relative 'game_theory/player_factory_class'
require_relative 'game_theory/earning_engine_class'
require_relative 'game_theory/two_player_logic_class'
require_relative 'game_theory/turn_engine_class'
require_relative 'game_theory/reporter_class'

# Generate Players - Will take options in the future
players = PlayerFactory.new(Player).generate_players

# Rules for granting earnings - acts on players instances
earning_engine = EarningEngine.new(players)

# Game logic - needs acces to the earning engine to grant earnings
logic_engine = TwoPlayerLogic.new(players, earning_engine)

# Engine that process turns - needs the logic engine to know how
turn_engine = TurnEngine.new(players, logic_engine)

# Game can be instantiated with the turn engine
GameLoop.new(turn_engine).run

at_exit { puts "\nMerci d'avoir joué.".yellow }
