# A class to manage behaviors
class BehaviorEngine
  include Displayable
  include Validable

  def initialize(behavior_class, history)
    Displayable.set_io_variables_on(self)
    @behavior_class = behavior_class
    @behaviors_list = behavior_class.behaviors
    @valid_choices = behavior_class.valid_behavior_choices
    @history = history
  end

  def choose_player_behavior
    choice = ask_behavior_to_player

    err_msg = "Impossible de gérer votre choix: #{choice}."
    raise StandardError,  err_msg if choice.nil?

    behavior = behaviors_list[choice]
    behavior_class.new(type: behavior, history: history)
  end

  private

  attr_reader :behavior_class, :behaviors_list, :valid_choices, :history

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
