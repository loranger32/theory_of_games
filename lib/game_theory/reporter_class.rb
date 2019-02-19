# Class to format results of games and turns
class Reporter
  def initialize
    @players = nil
  end

  def assign_players(players)
    @players = players
  end

  def display_game_report
    puts '*' * 30
    puts 'Les scores sont:'
    @players.each { |player| puts "- #{player.name}: #{player.score}." }
    puts ''
    puts '*' * 30
  end

  private

  attr_reader :players
end
