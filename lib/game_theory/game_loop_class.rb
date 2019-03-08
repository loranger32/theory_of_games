# Main Game Loop
class GameLoop
  include Displayable
  include Validable

  TURNS = 25

  attr_reader :players

  def initialize(turn_engine, reporter, player_factory)
    Displayable.set_io_variables_on(self)
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
      reset_players_score_and_history
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
    clear_screen
    print_message 'Tous les tours ont été joués.'
    reporter.display_report(history)
  end

  def ready_to_play?
    print_message 'Prêt à lancer le jeu ? (pressez une touche pour continuer)'
    gets.chomp
  end

  def reset_players_score_and_history
    @turn_engine.reset_players_score
    @turn_engine.reset_history!
  end

  def play_again?
    prompt 'On refait un essai (o/n) ?'
    @still_playing = false if obtain_a_valid_input_from(%w[o n]) == 'n'
  end

  attr_reader :player_factory, :turn_engine, :reporter, :report_type
end
