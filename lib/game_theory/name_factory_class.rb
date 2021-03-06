# A custom error class for invalid name argument
class InvalidNameArgumentError < ArgumentError; end

# Class responsible for name choice, both custom and random
class NameFactory
  # Allow word characters, maximum of 3 sequences separated by space(s)
  NAME_PATTERN = /\A\w+(\s+\w+){0,2}\z/.freeze
  NAME_ERRORS = { existent_name: 'Le nom existe déjà',
                  invalid_name: "le nom n'est pas valide" }.freeze

  attr_reader :choosen_names

  def initialize(random_name_list)
    @random_names = random_name_list
    @choosen_names = []
  end

  def name_errors
    NAME_ERRORS
  end

  def create_name(choice = nil)
    validate_argument(choice)
    choice.nil? || choice.empty? ? pick_random_name : process_choice(choice)
  end

  def pick_random_name
    name = random_names.shuffle.pop
    store_and_return_name(name)
  end

  def process_choice(name)
    if unique_name?(name) && valid_name?(name)
      store_and_return_name(name.chomp)
    elsif !unique_name?(name)
      :existent_name
    elsif !valid_name?(name)
      :invalid_name
    else
      raise InvalidNameArgumentError, "Could not proceed choice of '#{name}'"
    end
  end

  def reset_names!
    @choosen_names = []
  end

  private

  attr_reader :random_names

  def validate_argument(name)
    err_msg = "Invalide choice argument. Expect nil or a string, got #{name}\
 which is of class #{name.class}."
    raise InvalidNameArgumentError, err_msg unless \
      name.nil? || name.is_a?(String)
  end

  def unique_name?(name)
    !choosen_names.include?(name)
  end

  def store_and_return_name(name)
    choosen_names << name
    name
  end

  def valid_name?(name)
    name.match?(NAME_PATTERN)
  end
end
