# Class to format results of games and turns
class Reporter
  include Displayable
  include Validable
  include Tableable

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
    display_in_table(players,
                     headers: %w[nom comportement score],
                     attributes: %i[name behavior score])
  end

  def display_full_game_report(history)
    history.display
    wait_until_ready_to_go_on
  end

  private

  def want_full_report?
    question = 'Voulez-vous également un rapport détaillé tour par tour ?'
    colored_question = pastel.bright_blue(question)

    prompt.yes?(colored_question) do |q|
      q.positive 'Oui'
      q.negative 'Non'
    end
  end

  attr_reader :players
end
