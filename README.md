# Ruby Capstone Project - Ruby Linter

[![View Code](https://img.shields.io/badge/View%20-Code-green)](https://github.com/acushlakoncept/ruby-linter)
[![Github Issues](https://img.shields.io/badge/GitHub-Issues-orange)](https://github.com/acushlakoncept/ruby-linter/issues)
[![GitHub Pull Requests](https://img.shields.io/badge/GitHub-Pull%20Requests-blue)](https://github.com/acushlakoncept/ruby-linter/pulls)

<a text-align="center" href="#about">About</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
<a href="#method">User Interface</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
<a href="#ins">Input</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
<a href="#with">Output</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
<a href="#ldl">Class Definitions</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
<a href="#ldl">Built With</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
<a href="#ldl">Live Demo</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
<a href="#ldl">Getting Started</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
<a href="#author">Authors</a>




# About 

The whole idea of writing code to check another code is intriguing at the same time cognitively demanding. 
Building Linters for Ruby, the project provides feedback about errors or warning in code little by little. 
The project was built completely with Ruby following all possible best practices. Rubocop was used as a code-linter alongside Gitflow to ensure I maintain good coding standards.


# The Build
The custom Ruby linter currently checks/detects for the following errors/warnings.


# Instructions

## Input
- At the beginning of the game, the two players are requested to enter their names, one after the other.
- The first person to enter his/her name automatically becomes player 1 and is requested to enter values 
between [1 - 9] to mark a piece on the board.
- Player 1 is automatically assigned to piece "X" and player 2 piece "O"


## Output
- The board class is instantiated at the beginning of the game with unmarked spots 1 to 9 on a 3x3 grid.
- The game board is re-rendered on the screen to show player's current placement of piece. Example if 
  player 1 takes position 5, is replaced with "X" and becomes unvailable till the end of the game.
- This repeats until win or draw conditions are met
- Players instructions are error messages are displayed at each intervals to guide the players


# Class Definitions

### **Game Class**:
The game class initializes the **_board class_** and the **_player class_**. It handles the _check winner_ and _draw methods_ as well as _switch player method_.

### **Player Class**:
Will interact with Board class to select where to place pieces
Pieces placed will be represented by X or O

### **Board Class**:
Will display the game board as well as locations of marked spots
Take input from players to determine where to show marked spots





## Built With

- Ruby

## 🔴 Live Demo <a name = "ldl"></a>


[![Run on Repl.it](https://repl.it/badge/github/acushlakoncept/tic-tac-toe)](https://tic-tac-toe.acushla.repl.run/)


# Getting Started

To get a local copy of the repository please run the following commands on your terminal:

```
$ cd <folder>
```

```
$ git clone https://github.com/acushlakoncept/tic-tac-toe.git
```

**To run the code:** 

~~~bash
$ bin/main.rb
~~~

Testing

To test the code, run `rspec` from root of the folder using terminal.
> Rspec is used for the test.

~~~bash
$ gem install rspec
~~~


# Authors

👤 **Uduak Essien**

- Github: [@acushlakoncept](https://github.com/acushlakoncept/)
- Twitter: [@acushlakoncept](https://twitter.com/acushlakoncept)
- Linkedin: [acushlakoncept](https://www.linkedin.com/in/acushlakoncept/)

👤 **Elijah Ayandokun**

- Github: [@elijahtobs](https://github.com/elijahtobs)
- Linkedin: [Elijah Ayandokun](https://www.linkedin.com/in/ayandokunelijah/)
- Twitter: [@ElijahTobs](https://twitter.com/ElijahTobs)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

## Show your support

Give a ⭐️ if you like this project!

## Acknowledgments

- Project originally taken from The Odin Project
- Project inspired by [Microverse](https://www.microverse.org)
