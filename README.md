# Prsionner's Dilemma Simulation

## Overview

Small Cli program written in Ruby to play and simulate a version of the
[Prisonner's Dilemma](https://en.wikipedia.org/wiki/Prisoner%27s_dilemma), which
is a example of 
[the theory of games](https://en.wikipedia.org/wiki/Game_theory) situations.

Fun and learning are the main objectives.

It's for the moment only written in french, but english translation is foreseen.

## Main concept

Two players or more are playing a "cooperate or betray" game.

For each turn, each player must choose if he cooperates or betrays.

If all players cooperate, they all get 5 points.

If all players betray, they all get no points.

And if one betrays and the others cooperate, the one who betrays gets 10 points.

The number of rounds is determined before the game starts, and can range from
1 to 9999.

## What it does

5 behaviors have been modelled so far :

- Naive : always cooperates ;
- Traitor : always betrays ;
- Pick at random : randomy choose to cooperate or betray ;
- Quick Adapter : punish and forgive fast
                  (the so called '_tit for tat_.' strategy). As long as the
                  other player cooperates, he cooperates also. If the other
                  player betrays, he will betray the next time. As soon as the
                  other player cooperates again, he will also cooperate ;
- Slow Adapter : punish and forgives slowly. Same as above, except that he will
                 wait 3 turns before changing move ;


User can choose the number of turns to play (between 1 and 9999), and it will
be soon possible to run multiple sets of a given number of turns.

After the run of all the turns, a display of the total points is rendered,
with an option to see the details per turn and per player.


## Next steps

- more pre-defined behaviors ;
- allow user to define his own behaviors ;
- real time playing against other players (ai) with randomly selected behaviors;
- adaptative behaviors for the ai ;
- implement a version with a non predefined number of rounds;
- export results in various format (JSON, YAML, CSV, Markdown, html) ;
- implement other versions of the Prisonner's Dilemma ;
- english translation ;
- package it as a gem ;
- make a webapp ;
- develop a tool to analyse the results ;

See `todo.md` at the root of the directory to check the next steps.

For now (june 2019) it's still a WIP in the early stages.


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
