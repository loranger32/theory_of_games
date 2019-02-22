# Class responsible for name choice, both custom and random
class NameEngine
  include Displayable
  include Validable

  # Allow word characters, a new line or an empty string
  NAME_PATTERN = /\A[\w+]|\n|\z/.freeze

  def initialize(random_name_list)
    Displayable.set_io_variables_on(self)
    @random_names = random_name_list
    @choosen_names = []
  end

  def choose_player_name(player_number)
    name = ask_player_choice(player_number)

    # The comparison with nil is needed for the tests
    if name == '' || name.nil?
      pick_random_name
    else
      name = ensure_uniqueness_of(name)
      store_and_return_name(name.chomp)
    end
  end

  def pick_random_name
    random_name = random_names.sample

    random_name = random_names.sample while choosen_names.include?(random_name)

    store_and_return_name(random_name)
  end

  private

  attr_reader :random_names, :choosen_names

  def ask_player_choice(player_number)
    question = "Choisissez un nom pour le joueur #{player_number}, ou 'entrée'\
 pour un nom par défaut:"
    prompt(question)
    obtain_a_valid_input_from(NAME_PATTERN)
  end

  def ensure_uniqueness_of(name)
    while choosen_names.include?(name)
      prompt("Le nom #{name} est déjà pris, choisissez en un nouveau")
      name = input.gets
    end
    name
  end

  def store_and_return_name(name)
    choosen_names << name
    name
  end
end
