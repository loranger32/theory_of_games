# A module for all sort of input validation
# Must be included with Displayable or in a class that add special accessors
# and instance variable 'input' and 'output' to reference $stdin and $stdout
module Validable

# ========== Generic input validation mechanism ==========

  def obtain_a_valid_input_from_list(valid_choices_list)
    choice = retrieve_input

    until valid_choice?(choice, valid_choices_list)
      print_error_message("Choix invalide !")
      print_error_message("Les choix valides sont:")
      print_error_message(valid_choices_list.join(', ') + '.')
      prompt("Quel est votre choix ?")
      choice = retrieve_input.downcase
    end
    choice
  end

  def valid_choice?(choice, valid_choices_list)
    unless valid_choices_list.is_a?(Array)
      raise ArgumentError, "Valid_choices_list must be an Array,\
 was a #{valid_choices_list.class}"
    end
    valid_choices_list.include?(choice.downcase)
  end

  def retrieve_input
    choice = input.gets
    choice.nil? ? nil : choice.chomp
  end
end
