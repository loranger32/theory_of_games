# Class to format results of games and turns
class Reporter
  include Displayable
  include Validable

  COLOM_LENGTH = 20

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
    print_message('Les scores sont:', color: :light_blue)

    display_in_table(players, :name, :behavior, :score)
  end

  def display_full_game_report(history)
    print_message('*' * COLOM_LENGTH, color: :red)
    print_message('Résultats des matchs:', color: :yellow)
    history.display
    print_message('*' * COLOM_LENGTH, color: :red)
  end

  private

  def want_full_report?
    prompt("Voulez-vous également un rapport détaillé tour par tour (o/n) ?")
    obtain_a_valid_input_from(%w(o n)) == 'o'
  end

  attr_reader :players
end
