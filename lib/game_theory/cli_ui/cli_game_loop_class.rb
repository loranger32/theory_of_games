# rubocop:disable Metrics/ClassLength
# Main Game Loop
class CliGameLoop
  include Displayable
  include Validable
  include Tableable

  MAIN_MENU = %w[help - h].freeze

  attr_reader :turn_engine, :reporter, :player_factory, :players, :name_factory,
              :behavior_factory, :turns

  def initialize(turn_engine, reporter, player_factory, name_factory,
                 behavior_factory)
    Displayable.set_io_variables_on(self)
    @turn_engine      = turn_engine
    @reporter         = reporter
    @player_factory   = player_factory
    @name_factory     = name_factory
    @behavior_factory = behavior_factory
    @players          = nil
    @turns            = 0
  end

  # rubocop:disable Metrics/MethodLength
  def run
    loop do
      setup_players_and_turns
      loop do
        play_turns
        display_report_and_reset_history_and_scores
        break unless play_again_with_same_players_and_turn?
      end
      reset_players_and_turns!
      break unless play_again?
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def setup_players_and_turns
    create_players
    choose_number_of_turns
  end

  def create_players
    loop do
      players_data = collect_data_for_players
      @players = player_factory.create_players(players_data)

      break if confirm_players?

      collect_data_again
    end
    assign_players_to_engines
  end

  def choose_number_of_turns
    prompt 'Combien de tous souhaitez-vous faire (1 - 1000)'
    pattern = /\A\d{1,4}\z/
    answer = obtain_a_valid_input_from(pattern)
    @turns = answer.to_i
  end

  def assign_players_to_engines
    turn_engine.assign_players(players)
    reporter.assign_players(players)
  end

  def play_turns
    ready_to_play?
    turns.times { @turn_engine.play_turn }
  end

  def display_report_and_reset_history_and_scores
    display_report(turn_engine.history)
    reset_players_score_and_history
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
    prompt 'On refait un essai avec de nouveaux joueurs (o/n) ?'
    obtain_a_valid_input_from(%w[o n]) == 'o'
  end

  def play_again_with_same_players_and_turn?
    prompt 'Nouvel essai avec les mêmes joueurs et nombre de tours (o/n) ?'
    obtain_a_valid_input_from(%w[o n]) == 'o'
  end

  def collect_data_for_players
    number_of_players = ask_number_of_players_to_create
    collect_data_for_player_creation(number_of_players)
  end

  def ask_number_of_players_to_create
    message = pastel.bright_blue('Combien de joueurs voulez-vous (2 - 9) ?')
    error_msg = pastel.bright_red('Le nombre de joueur doit être entre 2 et 9')
    choice = prompt.ask(message) do |q|
      q.required
      q.in('0-9', error_msg)
    end
    choice.to_i
  end

  def collect_data_for_player_creation(number_of_players)
    players_data = []
    1.upto(number_of_players) do |player_number|
      player_data = {}
      player_data[:name]     = retrieve_player_name(player_number)
      player_data[:behavior] = retrieve_player_behavior(player_data[:name])
      players_data << player_data
    end
    players_data
  end

  def retrieve_player_name(player_number)
    choice = ask_player_name_choice(player_number)
    name   = name_factory.create_name(choice)
    verify_name_is_unique_and_valid(name)
  end

  def verify_name_is_unique_and_valid(name)
    while name_factory.name_errors.key?(name)
      print_error_message(name_factory.name_errors[name])
      prompt('Nouvel essai')
      name = name_factory.create_name(retrieve_input)
    end
    name
  end

  def retrieve_player_behavior(name)
    choice = ask_behavior_to_player(name)
    @behavior_factory.create_behavior(choice)
  end

  def ask_player_name_choice(player_number)
    question = "Choisissez un nom pour le joueur #{player_number}, ou 'entrée'\
 pour un nom par défaut:"
    prompt_center(question)
    retrieve_input
  end

  def ask_behavior_to_player(name)
    question = <<~QUESTION
      Choisissez le type ce comportement pour le joueur #{name}:
      - Naif (n)
      - Traitre (t)
      - au Hasard (h)
      - s'adapte Rapidement (r)
      - s'adapet Lentement (l)
    QUESTION

    prompt_center(question)
    obtain_a_valid_input_from_list BehaviorFactory::BEHAVIORS.keys
  end

  def confirm_players?
    clear_screen
    print_in_center('Vous avez choisi les joueurs suivant:')
    display_in_table(players, :name, :behavior)

    prompt_center('Confirmez vous ce choix ? (o/n)')
    obtain_a_valid_input_from(%w[o n]) == 'o'
  end

  def collect_data_again
    @players = nil
    name_factory.reset_names!
    print_message('Ok, on recommence.')
  end

  def reset_players_and_turns!
    @players = nil
    assign_players_to_engines
    name_factory.reset_names!
    @turns = 0
  end
end
# rubocop:enable Metrics/ClassLength
