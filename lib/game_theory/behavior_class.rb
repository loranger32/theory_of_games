

# Behavior class - stores the possible behaviors and the choose move logic
class Behavior
  

 
  def initialize(type:, history:)
    validate_arguments(type, history)
    @type = type
    @history = history
  end

  def choose_move(player)
    case type
    when :naive         then :cooperates
    when :traitor       then :betrays
    when :random        then choose_random_move
    when :quick_adapter then adapt_quickly(player)
    when :slow_adapter  then adapt_slowly(player)
    else
      :do_not_know
    end
  end

  def to_s
    TRANSLATIONS[type]
  end

  private

  

  

  def adapt_slowly(player)
    
  end

  def validate_arguments(type, history)
    validate_type(type)
    validate_history(history)
  end

  def validate_type(type)
    err_msg = "Invalid behavior argument. Got #{type}, but must be one of the \
 following: #{BEHAVIORS.values.join(', ')}."
    raise BehaviorArgumentError, err_msg unless BEHAVIORS.value?(type)
  end

  def validate_history(history)
    err_msg = "Invalid :history argument. Got '#{history}', of \
 class #{history.class}, and this class doesn't respond to \#store_turn"
    raise BehaviorArgumentError, err_msg unless history.respond_to?(:store_turn)
  end
end
