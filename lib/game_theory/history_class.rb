# A class to store the turns results
class History
  include Displayable
  include Enumerable
  include Tableable

  attr_reader :players, :turns

  def initialize
    @players = nil
    @turns = []
  end

  def assign_players(players)
    @players = players
  end

  def store_turn(turn)
    turns << turn
  end

  def empty?
    turns.empty?
  end

  def each
    turns.each do |turn|
      yield turn
    end
  end

  def last_turn
    turns.last
  end

  def last_three_turns
    turns[-3..-1]
  end

  def less_than_three_turns?
    turns.size < 3
  end

  def traitor_on_last_turn?(player)
    last_turn.any? do |player_turn|
      next if player_turn.name == player.name

      player_turn.a_traitor?
    end
  end

  def traitor_on_last_three_turns?(player)
    last_three_turns.all? do |turn|
      turn.any? do |player_turn|
        next if player_turn.name == player.name

        player_turn.a_traitor?
      end
    end
  end

  def naive_on_last_three_turns?(player)
    last_three_turns_of_other_players = exclude_player_own_turns(player)

    last_three_turns_of_other_players.all? do |turn|
      turn.all? do |player_turn|
        next if player_turn.name == player.name

        player_turn.a_naive?
      end
    end
  end

  def pick_last_move_of_player(player)
    last_player_turn = last_turn.find do |player_turn|
      player_turn.name == player.name
    end
    last_player_turn.move
  end

  def display
    each_with_index do |turn, index|
      title = "  Tour #{index + 1}  "
      padding = " " * title.size
      formatted_title = pastel.bright_black.bold.on_bright_blue(title)
      formatted_padding = (pastel.on_bright_blue(padding))

      display_boxed_centered_title(title, formatted_title, formatted_padding)

      display_in_table(turn,
                       attributes: [:name, :behavior, :display_move, :earning,
                                    :score],
                       headers: %w[NOM COMPORTEMENT ACTION GAIN SCORE])
    end
  end

  def reset!
    @turns = []
  end

  private

  def exclude_player_own_turns(player)
    last_three_turns.map do |turn|
      turn.reject do |player_turn|
        player_turn.name == player.name
      end
    end
  end
end
