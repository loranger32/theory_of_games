# Main Game Loop
class CliGameLoop
  include Displayable
  include Validable

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

  def run
    greet
    loop do
      create_players
      choose_number_of_turns
      loop do
        ready_to_play?
        turns.times { @turn_engine.play_turn }
        display_report(turn_engine.history)
        reset_players_score_and_history
        break unless play_again_with_same_players_and_turn?
      end
      reset_players_and_turns!
      break unless play_again?
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
    answer = obtain_a_valid_input_from /\A\d{1,4}\z/
    @turns = answer.to_i
  end

  def assign_players_to_engines
    turn_engine.assign_players(players)
    reporter.assign_players(players)
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
    prompt('Combien de joueurs voulez-vous (2 - 9) ?')
    pattern = /\A[2-9]\z/
    choice = obtain_a_valid_input_from(pattern)
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
    while %I[existent_name invalid_name].include?(name)
      if name == :existent_name
        prompt 'Ce nom existe déjà, veuillez en choisir un autre'
      elsif name == :invalid_name
        prompt 'Ce nom est invalide, veuillez en choisir un autre'
      end
      name = name_factory.create_name(retrieve_input)
    end
    name
  end

  def retrieve_player_behavior(name)
    choice = ask_behavior_to_player(name)
    behavior = @behavior_factory.create_behavior(choice)
  end

  def ask_player_name_choice(player_number)
    question = "Choisissez un nom pour le joueur #{player_number}, ou 'entrée'\
 pour un nom par défaut:"
    prompt(question)
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

    prompt(question)
    obtain_a_valid_input_from_list BehaviorFactory::BEHAVIORS.keys
  end

  def confirm_players?
    clear_screen
    print_message('Vous avez choisi les joueurs suivant:')
    display_in_table(players, :name, :behavior)

    prompt('Confirmez vous ce choix ? (o/n)')
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
