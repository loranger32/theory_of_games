# Main Game Loop
class GameLoop
  include Displayable

  TURNS = 30

  attr_reader :players

  def initialize(turn_engine, reporter, player_factory)
    @turn_engine = turn_engine
    @reporter = reporter
    @player_factory = player_factory
    @players = nil
    @still_playing = true
  end

  def run
    greet
    create_players
    while still_playing?
      ready_to_play?
      TURNS.times { @turn_engine.play_turn }
      display_report(turn_engine.history)
      reset_players_score
      play_again?
    end
  end

  private

  def greet
    clear_screen
    titleize(MAIN_TITLE)
    print_message 'Bienvenue dans cette simulation de la théorie des jeux.'
    skip_lines(2)
  end

  def create_players
    @players = player_factory.create_players
    assign_players_to_engines
  end

  def assign_players_to_engines
    turn_engine.assign_players(players)
    reporter.assign_players(players)
  end

  def still_playing?
    @still_playing
  end

  def display_report(history)
    print_message 'Tous les tours ont été joués.'
    reporter.display_report(history)
  end

  def ready_to_play?
    puts 'Prêt à lancer le jeu ? (pressez une touche pour continuer)'.blue
    gets.chomp
  end

  def reset_players_score
    @turn_engine.reset_players_score
  end

  def play_again?
    puts 'On refait un essai (o/n) ?'
    answer = gets.chomp.downcase
    until %w[o n].include?(answer)
      puts "Je n'ai pas compris. Veuillez choisir 'o' ou 'n'."
      answer = gets.chomp.downcase
    end
    @still_playing = false if answer == 'n'
  end

  attr_reader :player_factory, :turn_engine, :reporter, :report_type
end
