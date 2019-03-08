# The engine responsible for manging turns
class TurnEngine
  attr_reader :game_logic, :players, :history

  Turn = Struct.new(:name, :move, :display_move, :earning, :behavior, :score,
                    keyword_init: true) do
    def to_s
      <<~TURN
        #{name}:
        - behavior : #{behavior}
        - move : #{display_move}
        - earning : #{earning}
        - score : #{score}
        --------------------------
      TURN
    end

    def a_traitor?
      move == :betrays
    end

    def a_naive?
      move == :cooperates
    end
  end

  def initialize(game_logic, history)
    @players = nil
    @game_logic = game_logic
    @history = history
  end

  def assign_players(players)
    @players = players
    game_logic.assign_players(players)
    history.assign_players(players)
  end

  def play_turn
    players.each(&:play_move)
    game_logic.process_moves
    store_turn
    reset_players_turn_earning
    reset_players_move
  end

  def reset_players_score
    players.each(&:reset_score)
  end

  def reset_players_turn_earning
    players.each(&:reset_turn_earning)
  end

  def reset_history!
    @history.reset!
  end

  def store_turn
    formatted_turn = format_turn(players)
    history.store_turn(formatted_turn)
  end

  private

  def reset_players_move
    @players.map(&:reset_move)
  end

  def format_turn(players)
    players.each_with_object([]) do |player, container|
      container << Turn.new.tap do |turn|
        turn.name = player.name
        turn.move = player.move
        turn.display_move = player.display_move
        turn.earning = player.turn_earning
        turn.behavior = player.behavior
        turn.score = player.score
      end
    end
  end
end
