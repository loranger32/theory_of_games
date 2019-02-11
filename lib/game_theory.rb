#!/usr/bin/env ruby

require 'pry'
require 'colorize'

require_relative 'game_theory/game_loop_class'
require_relative 'game_theory/game_engine_class'
require_relative 'game_theory/player_factory_class'
require_relative 'game_theory/decision_maker_class'
require_relative 'game_theory/reporter_class'


GameLoop.new(GameTurnEngine.new(PlayerFactory.new.generate_players)).run

at_exit { puts "\nMerci d'avoir joué.".yellow }
