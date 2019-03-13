# A custom error class for the Player Factory Argument validation
class PlayerFactoryArgumentError < ArgumentError; end

# A class to generate the players
class PlayerFactory
  def initialize(player_class, score_class, behavior_class)
    @player_class      = player_class
    @score_class       = score_class
    @behavior_class    = behavior_class
  end

  def create_players(players_data)
    players_data.each_with_object([]) do |player_data, players|
      validate_player_data(player_data)

      players << player_class.new(name: player_data[:name],
                                  behavior: player_data[:behavior],
                                  score_recorder: score_class.new)
    end
  end

  private

  attr_reader :player_class, :score_class, :behavior_class

  def validate_player_data(player_data)
    validate_player_data_is_a_hash(player_data)
    validate_player_data_has_a_name_key_with_string_value(player_data)
    validate_player_data_has_a_behavior_key_with_behavior_value(player_data)
  end

  def validate_player_data_is_a_hash(player_data)
    err_msg = "Arguments list must be composed of hashes, got a\
 #{player_data.class} instead : #{player_data}"

    raise PlayerFactoryArgumentError, err_msg unless player_data.is_a? Hash
  end

  def validate_player_data_has_a_name_key_with_string_value(player_data)
    err_key = 'Player data must have a :name key, found none.'

    raise PlayerFactoryArgumentError, err_key unless player_data.key?(:name)

    err_val = "Player name value must be a string, got\
 #{player_data[:name]} of class #{player_data[:name].class} instead."

    raise PlayerFactoryArgumentError, err_val unless \
      player_data[:name].is_a?(String)
  end

  def validate_player_data_has_a_behavior_key_with_behavior_value(player_data)
    err_key = "Player data must have a :behavior key, found none\
 in #{player_data}."

    raise PlayerFactoryArgumentError, err_key unless player_data.key?(:behavior)

    err_val = "Player behavior value must be of Behavior class, got\
 #{player_data[:behavior]} of class #{player_data[:behavior].class} instead."

    raise PlayerFactoryArgumentError, err_val unless \
      player_data[:behavior].is_a?(behavior_class)
  end
end
