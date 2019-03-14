# A custom error class for invalid display_in_table argument
class TableArgumentError < ArgumentError; end

# Module to host all table relative methods
# Must be included with Displayable which defines methods which this module
# relies on
module Tableable

  # Define the length of the columns
  COLUMN_LENGTH = 25

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  # Could be refactored => for the gem
  def display_in_table(collection, *attributes)
    Helpers.validate_table_arguments(collection, attributes)

    print_message('+' * COLUMN_LENGTH * collection.size, color: :yellow)

    attributes.each do |attribute|
      collection.each do |item|
        print_on_line('|', color: :yellow)
        print_on_line(item.send(attribute).to_s.center(COLUMN_LENGTH - 2),
                      color: :yellow)
        print_on_line('|', color: :yellow)
      end
      skip_lines(1)
      print_message('-' * COLUMN_LENGTH * collection.size, color: :yellow) \
        unless attributes.index(attribute) == attributes.size - 1
    end

    print_message('+' * COLUMN_LENGTH * collection.size, color: :yellow)
    skip_lines(1)
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  module Helpers
    module_function

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

