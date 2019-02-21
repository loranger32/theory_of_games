class BehaviorEngine
  include Displayable

  def initialize(behaviors_list)
    @behaviors_list = behaviors_list
    @valid_choices = behaviors_list.keys
  end

  def choose_player_behavior
    choice = ask_behavior_to_player
    behavior = behaviors_list[choice]

    raise StandardError, "Impossible de gérer votre choix: #{choice}." if\
      behavior.nil?
    
    behavior
  end

  private

  attr_reader :behaviors_list, :valid_choices

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

    choice = gets.chomp
    until valid_choices.include?(choice)
      prompt("Choix incorrect, veuillez choisir #{valid_choices.join(', ')}.")
      choice = gets.chomp
    end
    choice
  end
end
