# A class to generate the players
class PlayerFactory
  include Displayable

  def initialize(player_class, score_class, name_engine)
    @player_class      = player_class
    @score_class       = score_class
    @name_engine = name_engine
  end

  def create_players
    number_of_players = ask_how_many_players_will_play
    players           = create_player_times(number_of_players)
    players
  end

  private

  def ask_how_many_players_will_play
    prompt('Combien de joueurs voulez-vous (2 - 9) ?')
    choice = gets.chomp
    until choice.match?(/\A[2-9]\z/)
      prompt('Valeur incorrecte. Choisissez un chiffre (2 - 9)')
      choice = gets.chomp
    end
    choice.to_i
  end

  def create_player_times(number_of_players)
    players = []
    number_of_players.times do |index|
      name = @name_engine.choose_player_name(index + 1)
      behavior = choose_player_behavior
      players << @player_class.new(@score_class.new, name: name,
                                                     behavior: behavior)
    end
    players
  end

  def choose_player_behavior
    choice = ask_behavior_to_player
    case choice
    when 'n' then :cooperator
    when 't' then :traitor
    when 'h' then :random
    else
      raise StandardError, "Impossible de gérer votre choix: #{choice}."
    end
  end

  def ask_behavior_to_player
    question = 'Choisissez le type ce comportement pour le joueur: \n'
    prompt(question + "- naif (n)\n- traitre (t)\n- au hasard (h)")
    choice = gets.chomp
    until %w[n t h].include?(choice)
      prompt("Choix incorrect, veuillez choisir 'n', 't ou 'h'.")
      choice = gets.chomp
    end
    choice
  end
end
