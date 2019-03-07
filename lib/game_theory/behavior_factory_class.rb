class BehaviorArgumentError < ArgumentError; end

# A class to create requested behavior for players
class BehaviorFactory
  include Displayable
  include Validable

  BEHAVIORS = { 'n' => :naive, 't' => :traitor, 'h' => :random,
                'r' => :quick_adapter, 'l' => :slow_adapter }.freeze

  BEHAVIOR_CLASSES = { naive: Naive, traitor: Traitor, random: PickRandom,
                       quick_adapter: QuickAdapter,
                       slow_adapter: SlowAdapter }. freeze

  attr_reader :history

  def initialize(history)
    Displayable.set_io_variables_on(self)
    @history = history
  end

  def create_behavior
    choice = ask_behavior_to_player
    requested_behavior = BEHAVIORS[choice]

    validate_type(requested_behavior)

    BEHAVIOR_CLASSES[requested_behavior].new(history)
  end

  private

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
    obtain_a_valid_input_from_list(BEHAVIORS.keys)
  end

  def validate_type(type)
    err_msg = "Invalid behavior argument. Got #{type} of class #{type.class},\
 but must be one of the following: #{BEHAVIORS.values.join(', ')}."
    raise BehaviorArgumentError, err_msg unless BEHAVIORS.value?(type)
  end
end
