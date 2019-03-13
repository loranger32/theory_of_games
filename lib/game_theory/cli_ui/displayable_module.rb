# The 'require' is needed for the tests
require 'colorize'

# A custom error class for invalid display_in_table argument
class TableArgumentError < ArgumentError; end

# A utils module to be included in various files to add display options
module Displayable
  SCREEN_WIDTH = 100
  COLOM_LENGTH = 20

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

  def print_message(message, color: nil)
    if color.nil?
      puts message.light_blue
    elsif Helpers.valid_color?(color)
      puts message.send(color)
    else
      puts message.light_blue
    end
  end

  def print_on_line(message, color: nil)
    if color.nil?
      print message.light_blue
    elsif Helpers.valid_color?(color)
      print message.send(color)
    else
      print message.light_blue
    end
  end

  def print_error_message(message)
    puts "\n#{message}".red
  end

  def prompt(message)
    puts message.green
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

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  # Could be refactored => for the gem
  def display_in_table(collection, *attributes)
    Helpers.validate_table_arguments(collection, attributes)

    print_message('+' * COLOM_LENGTH * collection.size, color: :yellow)

    attributes.each do |attribute|
      collection.each do |item|
        print_on_line('|', color: :yellow)
        print_on_line(item.send(attribute).to_s.center(COLOM_LENGTH - 2),
                      color: :yellow)
        print_on_line('|', color: :yellow)
      end
      skip_lines(1)
      print_message('-' * COLOM_LENGTH * collection.size, color: :yellow) \
        unless attributes.index(attribute) == attributes.size - 1
    end

    print_message('+' * COLOM_LENGTH * collection.size, color: :yellow)
    skip_lines(1)
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  # A helper module
  module Helpers
    module_function

    def valid_color?(color)
      String.colors.include?(color)
    end

    def validate_table_arguments(collection, attributes)
      validate_collection(collection)
      validate_attributes(collection[0], attributes)
    end

    def validate_collection(collection)
      err_msg = "The first argument must respond to each. #{collection.class}\
 objects usually do not."
      raise TableArgumentError, err_msg unless collection.respond_to?(:each)
    end

    def validate_attributes(item, attributes)
      attributes.each do |attribute|
        err_msg = "The attributes must be valid for the items in their\
 collection. ##{attribute} is not a valid attribute for objects of\
 class #{item.class}."
        raise TableArgumentError, err_msg unless item.respond_to?(attribute)
      end
    end
  end
end
