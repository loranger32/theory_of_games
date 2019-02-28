# Class to format results of games and turns
class Reporter
  include Displayable
  include Validable

  def initialize
    Displayable.set_io_variables_on(self)
    @players = nil
    @report_form = :short
  end

  def assign_players(players)
    @players = players
  end

  def define_form_report
    print_message("Veuillez choisir la forme de votre rapport:")
    print_message("- Tous les tours (t)")
    print_message("- Résultat final (r)")
    report_form = obtain_a_valid_input_from( %w[t r])
    if report_form == 't'
      @report_form = :long
    elsif report_form == 'r'
      @report_form = :short
    else
      @reportform = :short
    end
  end

  def display_report(history)
    case @report_form
    when :long then display_full_game_report(history)
    when :short then display_short_game_report
    else
      display_short_game_report
    end
  end

  def display_short_game_report
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

  attr_reader :players, :report_form
end
