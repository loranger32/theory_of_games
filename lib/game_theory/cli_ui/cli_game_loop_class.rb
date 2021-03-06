# rubocop:disable Metrics/ClassLength
# Main Game Loop
class CliGameLoop
  include Displayable
  include Validable
  include Tableable

  MAIN_TITLE = 'LA THEORIE DES JEUX - MODE INTERACTIF'.freeze
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

  private

  def setup_players_and_turns
    create_players
    choose_number_of_turns
  end

  def create_players
    loop do
      clear_screen_with_title_in_box(MAIN_TITLE)
      players_data = collect_data_for_players
      @players = player_factory.create_players(players_data)

      break if confirm_players?

      collect_data_again
    end
    assign_players_to_engines
  end

  def choose_number_of_turns
    clear_screen_with_title_in_box(MAIN_TITLE)

    question = pastel.bright_blue('Choisissez le nombre de tours (1 - 1000)')
    error_msg = pastel.bright_red('Choisissez un nombre entre 1 et 1000')
    answer = prompt.ask(question) do |q|
      q.validate(/\A\d{1,4}\z/, error_msg)
    end

    @turns = answer.to_i
  end

  def assign_players_to_engines
    turn_engine.assign_players(players)
    reporter.assign_players(players)
  end

  def play_turns
    clear_screen_with_title_in_box(MAIN_TITLE)
    turns.times { @turn_engine.play_turn }
  end

  def display_report_and_reset_history_and_scores
    display_report(turn_engine.history)
    reset_players_score_and_history
  end

  def display_report(history)
    clear_screen_with_title_in_box(MAIN_TITLE)
    title = '  Tous les tours ont été joués. Les résultats sont:  '
    padding = ' ' * title.length
    formatted_title = pastel.bright_black.on_bright_blue(title)
    formatted_padding = pastel.on_bright_blue(padding)
    display_boxed_centered_title(title, formatted_title, formatted_padding)

    reporter.display_report(history)
  end

  def reset_players_score_and_history
    @turn_engine.reset_players_score
    @turn_engine.reset_history!
  end

  def play_again?
    clear_screen_with_title_in_box(MAIN_TITLE)

    question = 'On refait un essai avec de nouveaux joueurs ?'
    formatted_question = pastel.bright_blue(question)
    prompt.yes?(formatted_question) do |q|
      q.positive 'Oui'
      q.negative 'Non'
      q.default 'Non'
    end
  end

  def play_again_with_same_players_and_turn?
    clear_screen_with_title_in_box(MAIN_TITLE)

    question = 'Nouvel essai avec les mêmes joueurs et nombre de tours ?'
    formatted_question = pastel.bright_blue(question)
    prompt.yes?(formatted_question) do |q|
      q.positive 'Oui'
      q.negative 'Non'
      q.default 'Non'
    end
  end

  def collect_data_for_players
    number_of_players = ask_number_of_players_to_create
    clear_screen_with_title_in_box(MAIN_TITLE)
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
      prompt.error(name_factory.name_errors[name])
      prompt.ok('Nouvel essai')
      # TO DO: Refactor to use the new TTY-Prompt Library
      name = name_factory.create_name(retrieve_input)
    end
    name
  end

  def retrieve_player_behavior(name)
    choice = ask_behavior_to_player(name)
    @behavior_factory.create_behavior(choice)
  end

  def ask_player_name_choice(player_number)
    clear_screen_with_title_in_box(MAIN_TITLE)

    question = pastel.bright_blue("Choisissez un nom pour le joueur\
 #{player_number}, ou 'entrée' pour un nom par défaut:")
    error_msg = pastel.red('Le nom doit comprendre entre 3 et 12 caractères')
    prompt.ask(question, error_msg)
  end

  def ask_behavior_to_player(name)
    clear_screen_with_title_in_box(MAIN_TITLE)

    question = "Choisissez le type ce comportement pour le joueur #{name}:"
    colorized_question = pastel.bright_blue(question)
    options = BehaviorFactory::BEHAVIORS.keys

    prompt.select(colorized_question, options)
  end

  def confirm_players?
    display_players_list

    display_in_table(players, attributes: %i[name behavior],
                              headers: %w[NOM COMPORTEMENT])

    prompt.yes?(pastel.bright_blue('Confirmez-vous ce choix ?')) do |q|
      q.positive 'Oui'
      q.negative 'Non'
      q.default 'Oui'
    end
  end

  def display_players_list
    clear_screen_with_title_in_box(MAIN_TITLE)
    title = '  Vous avez choisi les joueurs suivant:  '
    padding = ' ' * title.size
    formatted_title = pastel.bright_black.on_bright_blue(title)
    formatted_padding = pastel.on_bright_blue(padding)

    display_boxed_centered_title(title, formatted_title, formatted_padding)
  end

  def collect_data_again
    @players = nil
    name_factory.reset_names!
  end

  def reset_players_and_turns!
    @players = nil
    assign_players_to_engines
    name_factory.reset_names!
    @turns = 0
  end
end
# rubocop:enable Metrics/ClassLength
