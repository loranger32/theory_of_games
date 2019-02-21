# A class to generate the players
class PlayerFactory
  include Displayable

  attr_reader :players

  def initialize(player_class, score_class, name_engine, behavior_engine)
    @player_class    = player_class
    @score_class     = score_class
    @name_engine     = name_engine
    @behavior_engine = behavior_engine
    @players         = []
  end

  def create_players
    number_of_players = ask_number_of_players_to_create
    
    1.upto(number_of_players) do |player_number|
      name = @name_engine.choose_player_name(player_number)
      behavior = @behavior_engine.choose_player_behavior
      players << @player_class.new(@score_class.new, name: name,
                                                     behavior: behavior)
    end
    
    players
  end

  private

  def ask_number_of_players_to_create
    prompt('Combien de joueurs voulez-vous (2 - 9) ?')
    choice = gets.chomp
    until choice.match?(/\A[2-9]\z/)
      prompt('Valeur incorrecte. Choisissez un chiffre (2 - 9)')
      choice = gets.chomp
    end
    choice.to_i
  end
end
