class BehaviorArgumentError < ArgumentError; end

# A class to create requested behavior for players
class BehaviorFactory

  BEHAVIORS = { 'n' => :naive, 't' => :traitor, 'h' => :random,
                'r' => :quick_adapter, 'l' => :slow_adapter }.freeze

  BEHAVIOR_CLASSES = { naive: Naive, traitor: Traitor, random: PickRandom,
                       quick_adapter: QuickAdapter,
                       slow_adapter: SlowAdapter }.freeze

  attr_reader :history

  def initialize(history)
    @history = history
  end

  def create_behavior(choice)
    requested_behavior = process_choice(choice)
    validate_type(requested_behavior)

    BEHAVIOR_CLASSES[requested_behavior].new(history)
  end

  private

  def process_choice(choice)
    case choice
    when String then BEHAVIORS[choice]
    when Symbol then choice
    else
      err_msg = 'Argument of #process_choice must be String or Symbol'
      raise BehaviorArgumentError, err_msg
    end
  end

  def validate_type(type)
    err_msg = "Invalid behavior argument. Got #{type} of class #{type.class},\
 but must be one of the following: #{BEHAVIORS.values.join(', ')}."
    raise BehaviorArgumentError, err_msg unless BEHAVIORS.value?(type)
  end
end
