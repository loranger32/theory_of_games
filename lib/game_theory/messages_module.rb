module Messages
  def self.exit_game
    (system 'clear') || (system 'cls')
    print "Fermeture du jeux".yellow
    5.times do
      print '.'.yellow
      sleep(0.3)
    end
    puts '.'.yellow
    puts "Merci d'avoir joué.".yellow
  end
end
