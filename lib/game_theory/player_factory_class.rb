# A class to generate the players
class PlayerFactory
  include Displayable
  include Validable

  def initialize(player_class, score_class, name_engine, behavior_factory)
    Displayable.set_io_variables_on(self)
    @player_class      = player_class
    @score_class       = score_class
    @name_engine       = name_engine
    @behavior_factory  = behavior_factory
    @players           = []
  end

  def create_players
    loop do
      number_of_players = ask_number_of_players_to_create
      collect_data_for_player_creation(number_of_players)
      return players if confirm_players?

      collect_data_again
    end
  end

  private

  attr_reader :players, :player_class, :score_class, :name_engine,
              :behavior_factory

  def ask_number_of_players_to_create
    prompt('Combien de joueurs voulez-vous (2 - 9) ?')
    pattern = /\A[2-9]\z/
    choice = obtain_a_valid_input_from(pattern)
    choice.to_i
  end

  def collect_data_for_player_creation(number_of_players)
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

    behavior_choice = ask_behavior_to_player
    behavior = behavior_factory.create_behavior(behavior_choice)
    players << player_class.new(name: name, score_recorder: score_class.new,
                                behavior: behavior)
    end
  end

  def ask_player_name_choice(player_number)
    question = "Choisissez un nom pour le joueur #{player_number}, ou 'entrée'\
 pour un nom par défaut:"
    prompt(question)
    retrieve_input
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
end
