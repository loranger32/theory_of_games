class PlayerFactory
  include Displayable

  def initialize(player_class)
    @player_class = player_class
  end

  def create_players
    number_of_players = ask_how_many_players_will_play
    players = create_player_times(number_of_players)
    players
  end

  def ask_how_many_players_will_play
    prompt_for_answer("Combie de joueur voulez-vous (1 - 9) ?")
    choice = gets.chomp
    until choice.match?(/\A[1-9]\z/)
      prompt_for_answer("Valeur incorrecte. Choisissez un chiffre (1 - 9)")
      choice = gets.chomp
    end
    choice.to_i
  end

  def create_player_times(number_of_players)
    players = []
    number_of_players.times do |index|
      name = choose_player_name(index + 1)
      behavior = choose_player_behavior
      players << @player_class.new(name: name, behavior: behavior)
    end
    players
  end

  def choose_player_name(player_number)
    question = "Choisissez un nom pour le joueur #{player_number}, ou 'entrée'\
 pour un nom par défaut:"
    prompt_for_answer(question)
    choice = gets.chomp
    choice == '' ? player_class.random_name : choice
  end

  def choose_player_behavior
    question = "Choisissez le type ce comportement pour le joueur:"
    prompt_for_answer("- naif (n)\n- traitre (t)\n- au hasard (h)")
    choice = gets.chomp
    until %w[n t h].include?(choice)
      prompt_for_answer("Choix incorrect, veuillez choisir 'n', 't ou 'h'.")
      choice = gets.chomp
    end
    case choice
    when 'n' then :cooperator
    when 't' then :traitor
    when 'h' then :random
    else
      raise StandardError, "Impossible de gérer votre choix: #{choice}."
    end
  end
end
