# Main Game Loop
class CliGameLoop
  include Displayable
  include Validable

  TURNS = 25

  attr_reader :player_factory, :turn_engine, :reporter, :report_type, :players

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
    players_data = collect_data_for_players
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

  def collect_data_for_players
    loop do
      number_of_players = ask_number_of_players_to_create
      collect_data_for_player_creation(number_of_players)
      return players if confirm_players?

      collect_data_again
    end
  end

  def ask_number_of_players_to_create
    prompt('Combien de joueurs voulez-vous (2 - 9) ?')
    pattern = /\A[2-9]\z/
    choice = obtain_a_valid_input_from(pattern)
    choice.to_i
  end

  def collect_data_for_player_creation(number_of_players)
    #need to create a K/V collection to store players data
    1.upto(number_of_players) do |player_number|
      choice = ask_player_name_choice(player_number)
      name = name_engine.create_name(choice)
      while %I[existent_name invalid_name].include?(name)
        if name == :existent_name
          prompt 'Ce nom existe déjà, veuillez en choisir un autre'
        elsif name == :invalid_name
          prompt 'Ce nom est invalide, veuillez en choisir un autre'
        end
        
        choice = retrieve_input
        name = name_engine.create_name(choice)
      end
    end

    behavior_choice = ask_behavior_to_player
  end

  def ask_player_name_choice(player_number)
    question = "Choisissez un nom pour le joueur #{player_number}, ou 'entrée'\
 pour un nom par défaut:"
    prompt(question)
    retrieve_input
  end

  def ask_behavior_to_player
    question = <<~QUESTION
      Choisissez le type ce comportement pour le joueur:
      - Naif (n)
      - Traitre (t)
      - au Hasard (h)
      - s'adapte Rapidement (r)
      - s'adapet Lentement (l)
    QUESTION

    prompt(question)
    obtain_a_valid_input_from_list %w[t n h r l ]
  end

  def confirm_players?
    clear_screen
    print_message('Vous avez choisi les joueurs suivant:')
    display_in_table(players, :name, :behavior)

    prompt('Confirmez vous ce choix ? (o/n)')
    obtain_a_valid_input_from(%w[o n]) == 'o'
  end

  def collect_data_again
    @players = []
    @name_engine.reset_names!
    print_message('Ok, on recommence.')
  end
end
