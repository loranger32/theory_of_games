# Class to format results of games and turns
class Reporter
  include Displayable

  def initialize
    @players = nil
  end

  def assign_players(players)
    @players = players
  end

  def display_game_report
    print_message('*' * 30)
    print_message('Les scores sont:')
    @players.each { |player| print_message "- #{player.name}: #{player.score}." }
    print_message '*' * 30
  end

  def display_full_game_report(history)
    print_message('*' * 30)
    print_message('Résultats des matchs:')
    history.display
    print_message '*' * 30
  end

  private

  attr_reader :players
end
