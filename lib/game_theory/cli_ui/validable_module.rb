# A module for all sort of input validation
# Must be included with Displayable which adds special accessors
# and instance variable 'input' and 'output' to reference $stdin and $stdout
# AND extends the HelperMethods submodule
module Validable

  def obtain_a_valid_input_from(pattern)
    if pattern.is_a?(Array)
      obtain_a_valid_input_from_list(pattern)
    elsif pattern.is_a?(Regexp)
      obtain_a_valid_input_from_regexp(pattern)
    else
      raise ArgumentError, "Pattern must be an Array or a Regexp, was a\
 #{pattern.class}."
    end
  end

  def obtain_a_valid_input_from_list(valid_choices_list)
    choice = retrieve_input

    until valid_choices_list.include?(choice.downcase)
      HelperMethods.display_invalid_choice_from_list(valid_choices_list)
      choice = retrieve_input.downcase
    end
    choice
  end

  def obtain_a_valid_input_from_regexp(valid_pattern)
    choice = retrieve_input
    # TODO
    # comparison with nil is required for the tests - Needs to be fixed
    until  choice.nil? || choice.match?(valid_pattern)
      HelperMethods.display_invalid_choice_from_regexp
      choice = retrieve_input
    end
    choice
  end

  def retrieve_input
    choice = input.gets
    choice.nil? ? nil : choice.chomp
  end

  # Some private methods stored in a submodule
  module HelperMethods
    extend Displayable

    def self.display_invalid_choice_from_list(valid_choices_list)
      prompt.error('Choix invalide !')
      prompt.error('Les choix valides sont:')
      prompt.error(valid_choices_list.join(', ') + '.')
      prompt.ask('Quel est votre choix ?')
    end

    def self.display_invalid_choice_from_regexp
      prompt.error('Choix invalide !')
      prompt.ask('Quel est votre choix ?')
    end
  end
end
