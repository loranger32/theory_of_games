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
      name = name_engine.choose_player_name(player_number)
      behavior = behavior_factory.create_behavior
      players << player_class.new(name: name, score_recorder: score_class.new,
                                  behavior: behavior)
    end
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
    print_message('Ok, on recommence.')
  end
end
