# Class responsible for name choice, both cutsom and random
class NameEngine
  include Displayable

  def initialize(random_name_list)
    @random_names = random_name_list
    @choosen_names = []
  end
  
  def choose_player_name(player_number)
    choice = ask_player_choice(player_number)
    if choice == ''
      pick_random_name
    else
      while @choosen_names.include?(choice)
        prompt("Le nom #{choice} est déjà pris, choisissez en un nouveau")
        choice = gets.chomp
      end
      @choosen_names << choice
      choice
    end
  end

  def ask_player_choice(player_number)
    question = "Choisissez un nom pour le joueur #{player_number}, ou 'entrée'\
 pour un nom par défaut:"
    prompt(question)
    choice = gets.chomp
  end

  def pick_random_name
    random_name = @random_names.sample
    
    while @choosen_names.include?(random_name)
      random_name = random_names.sample
    end

    @choosen_names << random_name
    random_name
  end
end
