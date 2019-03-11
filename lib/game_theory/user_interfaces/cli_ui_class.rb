class CliUi
  include Displayable
  include Validable

  def initialize
    Displayable.set_io_variables_on(self)
  end
end
