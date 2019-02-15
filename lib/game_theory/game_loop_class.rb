class GameLoop
  TURNS = 3

  def initialize(turn_engine, reporter)
    @turn_engine = turn_engine
    @still_playing = true
    @reporter = reporter
    @players = []
  end

  def run
    greet
    while still_playing?
      ready_to_play?
      TURNS.times { @turn_engine.play_turn }
      display_end_of_turns
      reset_players_score
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
    @reporter.display_game_report
  end

  def ready_to_play?
    puts "Prêt à lancer le jeu ? (pressez une touche pour continuer)".blue
    gets.chomp
  end

  def reset_players_score
    @turn_engine.reset_players_score
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
