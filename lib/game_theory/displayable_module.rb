# A utils module to be included in game_loop_class but defined separately for
# clarity
module Displayable
  SCREEN_WIDTH = 100

  attr_accessor :input, :output

  def self.set_io_variables(object)
    object.input = $stdin
    object.output = $stdout
  end

  def titleize(title)
    title_size = title.size
    line = ('*' * (title_size + 10)).blue.center(SCREEN_WIDTH)
    title = title.red.center(SCREEN_WIDTH)
    puts line
    puts title
    puts line
    skip_lines(3)
  end

  def print_message(message)
    puts "\n#{message}".blue
  end

  def print_error_message(message)
    puts "\n#{message}".yellow
  end

  def prompt(message)
    puts message.to_s.green
    print '=> '.green
  end

  def clear_screen
    (system 'clear') || (system 'cls')
  end

  def clear_screen_with_title(title)
    clear_screen
    titleize(title)
  end

  def wait_until_ready_to_go_on
    prompt('Prêts ? (appuyer sur une touche pour continuer)')
    gets
  end

  def skip_lines(number_of_lines_to_skip)
    number_of_lines_to_skip.times { puts '' }
  end
end
