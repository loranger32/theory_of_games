# A class to manage behaviors
class BehaviorEngine
  include Displayable
  include Validable

  def initialize(behaviors_list)
    Displayable.set_io_variables_on(self)
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
    obtain_a_valid_input_from_list(valid_choices)
  end
end
