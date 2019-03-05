# Class to format results of games and turns
class Reporter
  include Displayable
  include Validable

  def initialize
    Displayable.set_io_variables_on(self)
    @players = nil
  end

  def assign_players(players)
    @players = players
  end

  def display_report(history)
    display_short_game_report
    display_full_game_report(history) if want_full_report?
  end

  def display_short_game_report
    print_message('*' * 30)
    print_message('Les scores sont:')

    @players.each do |player|
      print_message "- #{player.name}: #{player.score}."
    end

    print_message '*' * 30
  end

  def display_full_game_report(history)
    print_message('*' * 30)
    print_message('Résultats des matchs:')
    history.display
    print_message '*' * 30
  end

  private

  def want_full_report?
    prompt("Voulez-vous également un rapport détaillé tout par tour (o/n) ?")
    answer = obtain_a_valid_input_from(%w(o n))
    answer == 'o'
  end

  attr_reader :players
end
