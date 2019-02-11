#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
require 'bundler/setup'
Bundler.require(:default, :development)

require_relative 'game_theory/game_loop_class'
require_relative 'game_theory/game_turn_engine_class'
require_relative 'game_theory/player_factory_class'
require_relative 'game_theory/decision_maker_class'
require_relative 'game_theory/reporter_class'

players = PlayerFactory.new.generate_players
game_turn_engine = GameTurnEngine.new(players)

GameLoop.new(game_turn_engine).run

at_exit { puts "\nMerci d'avoir joué.".yellow }
