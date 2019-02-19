class PlayerFactory
  include Displayable

  def initialize(player_class, score_class)
    @player_class = player_class
    @score_class = score_class
  end

  def create_players
    number_of_players = ask_how_many_players_will_play
    players = create_player_times(number_of_players)
    players
  end

  def ask_how_many_players_will_play
    prompt("Combien de joueur voulez-vous (2 - 9) ?")
    choice = gets.chomp
    until choice.match?(/\A[2-9]\z/)
      prompt("Valeur incorrecte. Choisissez un chiffre (2 - 9)")
      choice = gets.chomp
    end
    choice.to_i
  end

  def create_player_times(number_of_players)
    players = []
    number_of_players.times do |index|
      name = choose_player_name(index + 1)
      behavior = choose_player_behavior
      players << @player_class.new(@score_class.new, name: name, behavior: behavior)
    end
    players
  end

  def choose_player_name(player_number)
    question = "Choisissez un nom pour le joueur #{player_number}, ou 'entrée'\
 pour un nom par défaut:"
    prompt(question)
    choice = gets.chomp
    choice == '' ? player_class.random_name : choice
  end

  def choose_player_behavior
    question = "Choisissez le type ce comportement pour le joueur:"
    prompt("- naif (n)\n- traitre (t)\n- au hasard (h)")
    choice = gets.chomp
    until %w[n t h].include?(choice)
      prompt("Choix incorrect, veuillez choisir 'n', 't ou 'h'.")
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
