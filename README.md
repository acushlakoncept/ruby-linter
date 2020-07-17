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
- check for wrong indentation
- check for trailing spaces
- check for missing/unexpected tags i.e. '( )', '[ ]', and '{ }'
- check missing/unexpected end
- check empty line error

> Below are demonstrations of good and bad code for the above cases. I will use the pipe '|' symbol to indicate cursor position where necessary.

## Indentation Error Check
~~~ruby
# Good Code

class Ticket
  def initialize(venue, date)
    @venue = venue
    @date = date
  end
end

# Bad Code

class Ticket
  def initialize(venue, date)
    @venue = venue
      @date = date
  end
end
~~~

## Trailing spaces
> note where the cursor(|) is on the bad code 
~~~ruby
# Good Code

class Ticket
  def initialize(venue, date)
    @venue = venue
    @date = date
  end
end

# Bad Code

class Ticket
  def initialize(venue, date)  |
    @venue = venue
    @date = date
  end
end
~~~

## Missing/Unexpected Tag
~~~ruby
# Good Code

class Ticket
  def initialize(venue, date)
    @venue = venue
    @date = date
  end
end

# Bad Code

class Ticket
  def initialize(venue, date
    @venue = venue
    @date = [[date]
  end
end
~~~

## Missing/unexpected end
~~~ruby
# Good Code

class Ticket
  def initialize(venue, date)
    @venue = venue
    @date = date
  end
end

# Bad Code

class Ticket
  def initialize(venue, date)
    @venue = venue
    @date = date
  end
  end
end
~~~

## Empty line error
~~~ruby
# Good Code

class Ticket
  def initialize(venue, date)
    @venue = venue
    @date = date
  end
end

# Bad Code

class Ticket
  def initialize(venue, date)

    @venue = venue
    @date = date
  end
end
~~~

## Built With
- Ruby


# Getting Started

To get a local copy of the repository please run the following commands on your terminal:

```
$ cd <folder>
```

```
$ git clone https://github.com/acushlakoncept/ruby-linter.git
```

**To check for errors on a file:** 

~~~bash
$ bin/main filename.rb
~~~

Testing

To test the code, run `rspec` from root of the folder using terminal.
> Rspec is used for the test.

~~~bash
$ gem install rspec
~~~


# Author

👤 **Uduak Essien**

- Github: [@acushlakoncept](https://github.com/acushlakoncept/)
- Twitter: [@acushlakoncept](https://twitter.com/acushlakoncept)
- Linkedin: [acushlakoncept](https://www.linkedin.com/in/acushlakoncept/)


## 🤝 Contributing

Contributions, issues and feature requests are welcome!

## Show your support

Give a ⭐️ if you like this project!

## Acknowledgments

- Project inspired by [Microverse](https://www.microverse.org)
