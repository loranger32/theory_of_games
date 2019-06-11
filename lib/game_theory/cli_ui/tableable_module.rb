# A custom error class for invalid display_in_table argument
class TableArgumentError < ArgumentError; end

# Module to host all table relative methods
module Tableable
  def create_table_with(collection, attributes, headers)
    Helpers.validate_table_arguments(collection, attributes)

    data = collection.map do |item|
      attributes.map { |attribute| item.send(attribute) }
    end

    TTY::Table.new(headers, data)
  end

  def display_in_table(collection, attributes: [], headers: [])
    table = create_table_with(collection, attributes, headers)
    table = table.render(:unicode) do |r|
      r.padding = [1, 2, 1, 2]
      r.width = 200
      r.border.style = :bright_blue
      r.alignments = %i[center center]
    end

    print_table_in_center(table)
    skip_lines(1)
  end

  def print_table_in_center(table)
    print cursor.down(2)

    table.each_line do |line|
      print cursor.forward((screen_width / 2) - half_table_width_of(table))
      puts line
    end
  end

  def half_table_width_of(table)
    table.scan(/.+┐/)[0].sub(/\e...m/, '').size / 2
  end

  # A simple module of helpers
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
        err_msg = "The attributes must be valid for the items in the\
 collection. ##{attribute} is not a valid attribute for objects of\
 class #{item.class}."
        raise TableArgumentError, err_msg unless item.respond_to?(attribute)
      end
    end
  end
end
