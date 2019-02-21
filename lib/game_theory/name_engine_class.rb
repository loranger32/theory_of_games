# Class responsible for name choice, both cutsom and random
class NameEngine
  include Displayable

  def initialize(random_name_list)
    @random_names = random_name_list
    @choosen_names = []
  end
  
  def choose_player_name(player_number)
    name = ask_player_choice(player_number)
    if name == ''
      pick_random_name
    else
      name = ensure_uniqueness_of(name)
      store_and_return_name(name)
    end
  end

  def pick_random_name
    random_name = random_names.sample
    
    while choosen_names.include?(random_name)
      random_name = random_names.sample
    end

    store_and_return_name(random_name)
  end

  private

  attr_reader :random_names, :choosen_names

  def ask_player_choice(player_number)
    question = "Choisissez un nom pour le joueur #{player_number}, ou 'entrée'\
 pour un nom par défaut:"
    prompt(question)
    choice = gets.chomp
  end

  def ensure_uniqueness_of(name)
    while choosen_names.include?(name)
      prompt("Le nom #{name} est déjà pris, choisissez en un nouveau")
      name = gets.chomp
    end
    name
  end

  def store_and_return_name(name)
    choosen_names << name
    name
  end
end
