# The 'require' is needed for the tests
require 'colorize'

# A utils module to be included in game_loop_class but defined separately for
# clarity
module Displayable
  SCREEN_WIDTH = 100

  # Method to be called in the initialize method of classes that implement
  # the module, in order to perform the tests with custom StringIO objects
  # rubocop:disable Naming/AccessorMethodName
  def self.set_io_variables_on(object)
    object.input = $stdin
    object.output = $stdout
  end
  # rubocop:enable Naming/AccessorMethodName

  # Accessors to use the $stdin and $stdout objects in the instances of the
  # including class
  attr_accessor :input, :output

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
