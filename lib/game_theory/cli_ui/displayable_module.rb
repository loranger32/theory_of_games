# The 'require' is needed for the tests
require 'colorize'

# A custom error class for invalid display_in_table argument
class TableArgumentError < ArgumentError; end

# A utils module to be included in various files to add display options
module Displayable

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

  def cursor
    TTY::Cursor
  end

  def prompt
    @prompt ||= TTY::Prompt.new(active_color: :bright_blue)
  end

  def pastel
    @pastel ||= Pastel.new
  end

  def screen_height
    TTY::Screen.size[0]
  end

  def screen_width
    TTY::Screen.size[1]
  end

  def titleize(title)
    title_size = title.size
    line = ('*' * (title_size + 10)).blue.center(screen_width)
    title = title.red.center(screen_width)
    puts line
    puts title
    puts line
    skip_lines(3)
  end

  def underline(message, text_color: :white, underline_color: :white)
    message_size = message.size
    underline = '-' * (message_size)

    if Helpers.valid_pastel_colors?([text_color, underline_color])
      underline = pastel.send(underline_color, underline)
      message = pastel.send(text_color, message)
    end

    puts message
    puts underline
    skip_lines(1)
  end

  def titleize_in_box(title)
    box_width = 50
    box_height = 5
    box = TTY::Box.frame(top: 1,
                         left: (screen_width / 2) - (box_width / 2),
                         width: box_width,
                         height: box_height,
                         align: :center,
                         padding: 1,
                         style: {
                           fg: :red,
                           bg: :bright_green,
                           border: {
                           fg: :red,
                           bg: :bright_green
                           }
                         }) do
                            title
                        end
    puts box
  end

  def display_in_small_box(message)
    box_width = message.size + 10
    box_height = 3
    box = TTY::Box.frame(top: 10,
                         left: ((screen_width / 2) - (box_width / 2)),
                         width: box_width,
                         height: box_height,
                         align: :center,
                         padding: 0,
                         style: {
                           fg: :bright_black,
                           bg: :bright_blue,
                           border: {
                            bg: :bright_blue,
                            fg: :bright_blue,
                           }
                         }) do
                            message
                          end
    puts box                     
  end

  def print_message(message, color: nil)
    if Helpers.valid_color?(color)
      puts message.send(color)
    else
      puts message.light_blue
    end
  end

  def print_on_line(message, color: nil)
    if Helpers.valid_color?(color)
      print message.send(color)
    else
      print message.light_blue
    end
  end

  def print_error_message(message)
    puts "\n#{message}".red
  end

  def prompt_t(message)
    puts message.green
    print '=> '.green
  end

  def prompt_center(message)
    half_msg_length = message.length / 2
    print cursor.down(2) + cursor.forward((screen_width / 2) - half_msg_length)
    print_message(message, color: :green)
    print (cursor.forward((screen_width / 2) - half_msg_length))
    print("=> ".green)
  end

  def print_in_center(message)
    half_msg_length = message.length / 2
    print cursor.down(2) + cursor.forward((screen_width / 2) - half_msg_length)
    print_message(message, color: :blue)
  end

  def clear_screen
    (system 'clear') || (system 'cls')
  end

  def clear_screen_with_title(title)
    clear_screen
    titleize(title)
  end

  def clear_screen_with_title_in_box(title)
    clear_screen
    titleize_in_box(title)
    skip_lines(3)
  end

  def wait_until_ready_to_go_on
    prompt('Prêts ? (appuyer sur une touche pour continuer)')
    gets
  end

  def skip_lines(number_of_lines_to_skip)
    number_of_lines_to_skip.times { puts '' }
  end

  # A helper module
  module Helpers
    module_function

    def pastel
      @@pastel ||= Pastel.new
    end

    def valid_color?(color)
      String.colors.include?(color)
    end

    def valid_pastel_colors?(colors)
      colors.all? do |color|
        binding.pry
        pastel.valid?(color)
      end
    end
  end
end
