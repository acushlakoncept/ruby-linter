require 'colorize'
require 'strscan'
require_relative 'file_reader.rb'

class CheckError
  attr_reader :checker
  attr_accessor :errors, :open_t, :close_t

  def initialize(file_path)
    @checker = FileReader.new(file_path)
    @errors = []
    @open_t = []
    @close_t = []
    @keywords = %w[begin case class def do if module unless]
    @keywords_count = {}
    @keywords.each { |val| @keywords_count[val] = 0 }
    @matched = []
  end

  def check_trailing_spaces
    @checker.file_lines.each_with_index do |str_val, index|
      if str_val[-2] == ' '
        @errors << "line:#{index + 1}:#{str_val.size - 1}: Error: Trailing whitespace detected. "
        + " '#{str_val.gsub(/\s*$/, '_')}' "
      end
    end
  end

  def check_indentation
    res_word = %w[class def if elsif until]
    msg = 'IndentationWidth: Use 2 spaces for indentation.'
    indent_reg = %r{^\s{2}\w}
    @checker.file_lines.each_with_index do |str_val, indx|
      m = @checker.file_lines[indx + 1]

      if res_word.include?(str_val.strip.split(' ').first) && !@checker.file_lines[indx + 1].strip.empty?
        @errors << "line:#{indx + 2} #{msg}" unless m.match?(indent_reg)
      end

      if str_val.strip == 'end' && !@checker.file_lines[indx - 1].strip.empty?
        @errors << "line:#{indx } #{msg}" unless @checker.file_lines[indx - 1].match?(indent_reg) 
      end

      if str_val.strip.split(' ').include?('do') && !@checker.file_lines[indx + 1].strip.empty?
        @errors << "line:#{indx + 2} #{msg}" unless m.match?(indent_reg)
      end

      if str_val.strip.split(' ').first.eql?('when') && !str_val.strip.split(' ').include?('then') && !@checker.file_lines[indx + 1].strip.empty?
        @errors << "line:#{indx + 2} #{msg}" unless m.match?(indent_reg)
      end

      # p 'gotcha' if str_val.strip == 'end'
    end

  end

  def check_tag_error(*args)
    @checker.file_lines.each_with_index do |str_val, index|
      open_p = []
      close_p = []
      open_p << str_val.scan(args[0])
      close_p << str_val.scan(args[1])

      status = open_p.flatten.size <=> close_p.flatten.size

      @errors << "line:#{index + 1} Lint/Syntax: Unexpected/Missing token '#{args[2]}' #{args[4]}" if status.eql?(1)
      @errors << "line:#{index + 1} Lint/Syntax: Unexpected/Missing token '#{args[3]}' #{args[4]}" if status.eql?(-1)
    end
  end

  def tag_error
    check_tag_error(/\(/, /\)/, '(', ')', 'Parenthesis')
    check_tag_error(/\[/, /\]/, '[', ']', 'Square Bracket')
    check_tag_error(/\{/, /\}/, '{', '}', 'Curly Bracket')
  end

  # THINK ABOUT REFACTORING TO INCLUDE LINE NUMBER ---------
  def end_error
    keyw_count = 0
    end_count = 0
    @checker.file_lines.each_with_index do |str_val, _index|
      keyw_count += 1 if @keywords.include?(str_val.split(' ').first) || str_val.split(' ').include?('do')
      end_count += 1 if str_val.strip == 'end'
    end

    status = keyw_count <=> end_count
    @errors << "Lint/Syntax: Missing 'end'" if status.eql?(1)
    @errors << "Lint/Syntax: Unexpected 'end'" if status.eql?(-1)
  end

  def empty_line_error
    @checker.file_lines.each_with_index do |str_val, indx|
      check_class_empty_line(str_val, indx)
      check_def_empty_line(str_val, indx)
      check_end_empty_line(str_val, indx)
      check_do_empty_line(str_val, indx)
    end
  end

  def check_class_empty_line(str_val, indx)
    msg = 'Extra empty line detected at class body beginning'
    return unless str_val.strip.split(' ').first.eql?('class')

    @errors << "line:#{indx + 2} #{msg}" if @checker.file_lines[indx + 1].strip.empty?
  end

  def check_def_empty_line(str_val, indx)
    msg1 = 'Extra empty line detected at method body beginning'
    msg2 = 'Use empty lines between method definition'

    return unless str_val.strip.split(' ').first.eql?('def')

    @errors << "line:#{indx + 2} #{msg1}" if @checker.file_lines[indx + 1].strip.empty?
    @errors << "line:#{indx + 1} #{msg2}" if @checker.file_lines[indx - 1].strip.split(' ').first.eql?('end')
  end

  def check_end_empty_line(str_val, indx)
    return unless str_val.strip.split(' ').first.eql?('end')

    @errors << "line:#{indx} Extra empty line detected at block body end" if @checker.file_lines[indx - 1].strip.empty?
  end

  def check_do_empty_line(str_val, indx)
    msg = 'Extra empty line detected at block body beginning'
    return unless str_val.strip.split(' ').include?('do')

    # @errors << "line:#{indx + 2} #{msg}" if @checker.file_lines[indx + 1].strip.empty?
  end

  def log_error(error_msg)
    @errors << error_msg
  end
end

ch = CheckError.new('bug.rb')
ch.check_trailing_spaces
ch.tag_error
ch.end_error
ch.empty_line_error
ch.check_indentation
ch.errors.each { |err| puts err.colorize(:red) }
