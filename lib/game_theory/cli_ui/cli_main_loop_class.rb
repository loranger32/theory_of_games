# Main Loop class
class CliMainLoop
  include Displayable
  include Validable

  MAIN_TITLE = 'LA THEORIE DES JEUX - SIMULATION'.freeze
  MAIN_MENU_TEXT = <<~MENU.freeze
    Interface interactive - i
                              
    Interface rapide - r
                           
    Aide - h
                           
    A propos - a
                       
    Quitter - q
  MENU

  attr_reader :main_box, :cli_game_loop

  def initialize(cli_game_loop)
    Displayable.set_io_variables_on(self)
    @main_box = generate_main_box
    @cli_game_loop = cli_game_loop
    @quit = false
  end

  def run
    greet
    loop do
      display_main_menu
      process_choice
      break if quit?
    end
  end

  private

  def greet
    clear_screen
    titleize_in_box(MAIN_TITLE)
  end

  # rubocop:disable Metrics/MethodLength
  def generate_main_box
    box_height = 15
    box_width = 40
    TTY::Box.frame(top: (screen_height / 2) - (box_height / 2),
                   left: (screen_width / 2) - (box_width / 2),
                   width: box_width,
                   height: box_height,
                   align: :center,
                   padding: 2,
                   title: { top_left: 'Menu principal',
                            bottom_right: 'version ' + VERSION },
                   style: { fg: :bright_yellow,
                            bg: :blue,
                            border: { fg: :bright_yellow,
                                      bg: :blue } }) do
                                        MAIN_MENU_TEXT
                                      end
  end
  # rubocop:enable Metrics/MethodLength

  def display_main_menu
    puts main_box
  end

  def process_choice
    choice = retrieve_menu_choice

    case choice
    when 'q' then @quit = true
    when 'i' then start_interactive_session
    end
  end

  # rubocop:disable Metrics/AbcSize
  def retrieve_menu_choice
    message = 'Entrez votre choix'
    formatted_message = pastel.bright_blue(message)

    print cursor.down(2)
    print cursor.forward((screen_width / 2) - message.size / 2)
    prompt.keypress(formatted_message, %i[i r h a q])
  end
  # rubocop:enable Metrics/AbcSize

  def start_interactive_session
    sleep(0.3)
    cli_game_loop.run
  end

  def quit?
    @quit
  end
end
