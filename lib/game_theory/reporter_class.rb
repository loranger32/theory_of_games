class Reporter
  def initialize(players)
    @players = players
  end

  def display_game_report
    puts '*' * 30
    puts "Les scores sont:"
    @players.each { |player| puts "- #{player.name}: #{player.score}." }
    puts ''
    puts '*' * 30
  end
end
