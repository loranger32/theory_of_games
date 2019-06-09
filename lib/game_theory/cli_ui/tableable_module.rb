# A custom error class for invalid display_in_table argument
class TableArgumentError < ArgumentError; end

# Module to host all table relative methods
module Tableable
  def create_table_with(collection, attributes)
    Helpers.validate_table_arguments(collection, attributes)

    table_data = hashify_data(collection, attributes)

    TTY::Table.new(table_data[:headers], table_data[:data],
                   orientation: :vertical)
  end

  def hashify_data(collection, attributes)
    headers = collection.map { |item| item.send(attributes[0]) }

    data = attributes[1...].map do |attribute|
      collection.map { |item| item.send(attribute) }
    end

    { headers: headers, data: data }
  end

  def display_in_table(collection, *attributes)
    table = create_table_with(collection, attributes)
    table = table.render(:unicode) do |r|
              r.padding  = [1, 2, 1, 2]
              r.width = 40
              r.border.style = :bright_green
              r.alignments = [:center]
            end
    
    puts table
    skip_lines(1)
  end

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

