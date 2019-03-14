# Theory of Games Simulation

Small Cli program written in Ruby to play and simulate some of
[the theory of games](https://en.wikipedia.org/wiki/Game_theory) situations.

Fun and learning are the main objectives.

It's for the moment only written in french, but english translation is on its
way.

5 behaviors have been modelled so far :

- Naive : always cooperates
- Traitor : always betrays
- Pick at random : randomy choose to cooperate or betray
- Quick Adapter : punish and forgive fast. As long as the other player
                  cooperates, he cooperates also. If the other player betrays,
                  he will betray the next time. As soon as the other player
                  cooperates again, he will also cooperate.
- Slow Adapter : punish and forgives slowly. Same as above, except that he will
                 wait 3 turns before changing move


User can choose the number of turns to play (between 1 and 9999), and it will
be soon possible to run multiple runs af a given number of turns.

After each run, a display of the total points is rendered, with an option to
see the detail per turn.

Special attention will be paid to get a fancy display in the terminal,
partly using the various [TTY gems](https://piotrmurach.github.io/tty/).

Next steps :

- more pre-defined behaviors ;
- allow user to define his own behaviors ;
- real time playing against other players (ai) with randomly selected behaviors;
- export results in various format (JSON, YAML, CSV, Markdown, html) ;
- english translation ;
- package it as a gem ;
- make a webapp ;
- develop a tool to analyse the results ;

See `todo.md` at the root of the directory to check the next steps.

For now (march 2019) it's still a WIP in the early stages.


# Installation

The intention is to package this small program as a gem to ease the
installation process.

For the time being, simple clone or download the project, and from the root of
the directory run `ruby lib/game_theory.rb`.


# Tests

This project is tested under `minitest`.

Run `rake` or `rake test` to run the test suite.

Style is monitored thanks to `rubocop`.


# Contribute

Think it could be better ?

- Fork it ;
- Create your own branch (`git checkout -b my-new-feature`) ;
- Make your feature addition or bug fix ;
- Add tests for it ;
- Commit on your own branch ;
- Push to the branch (`git push origin my-new-feature`) ;
- Create a new pull request ;

# Author

Laurent Guinotte


# Licence

This program is released under the GPL-3.0 Licence. See LICENCE.txt
for further details.
