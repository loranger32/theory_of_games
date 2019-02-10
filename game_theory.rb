#!/usr/bin/env ruby
require 'pry'
require 'colorize'

class Player
end

class PlayerFactory
  def generate_players
  end
end

class DecisionFactory
end

class Reporter
end

class GameEngine
  def initialize(players)
    @players = players
  end

  def play_turn
    puts "vous jouez".blue
  end
end

class GameLoop
  TURNS = 3

  def initialize(game_engine)
    @game_engine = game_engine
    @still_playing = true
  end

  def run
    greet
    while still_playing?
      ready_to_play?
      TURNS.times { @game_engine.play_turn }
      display_end_of_turns
      play_again?
    end
  end

  private

  def still_playing?
    @still_playing
  end

  def greet
    puts "Bienvenue à la théorie des jeux en pratique\n\n".red
  end

  def display_end_of_turns
    puts "Tous les tours ont été joués.\n"
  end

  def ready_to_play?
    puts "Prêt à lancer le jeu ? (pressez une touche pour continuer)".blue
    gets.chomp
  end



  def play_again?
    puts "On refait un essai (o/n) ?"
    answer = gets.chomp.downcase
    until ['o', 'n'].include?(answer)
      puts "Je n'ai pas compris. Veuillez choisir 'o' ou 'n'."
      answer = gets.chomp.downcase
    end
    @still_playing = false if answer == 'n'
  end
end


GameLoop.new(GameEngine.new(PlayerFactory.new.generate_players)).run

at_exit { puts "Merci d'avoir joué.".yellow }
