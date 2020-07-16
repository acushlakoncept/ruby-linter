require 'colorize'
require 'strscan'
require_relative 'file_reader.rb'
require 'parser/ruby24'

class CheckError
  attr_reader :checker
  attr_accessor :errors

  def initialize(file_path)
    @checker = FileReader.new(file_path)
    @errors = []
    @keywords = %w[begin case class def do if module unless]
    @keywords_count = {}
    @keywords.each { |val| @keywords_count[val] = 0 }
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
    msg = 'IndentationWidth: Use 2 spaces for indentation.'
    indent_reg = /^\s{2}\w/
    file_arr = @checker.file_lines

    cur_val = 0
    indent_val = 0

    file_arr.each_with_index do |str_val, indx|
      strip_line = str_val.strip.split(' ')
      exp_val = cur_val * 2
      res_word = %w[class def if elsif until module unless begin case]

      next unless !str_val.strip.empty? || !strip_line.first.eql?('#')
      emp = str_val.match(/^\s*\s*/)

      if res_word.include?(strip_line.first) || strip_line.include?('do')
        indent_val += 1
      elsif str_val.strip == 'end'
        indent_val -= 1
      end


      end_chk = emp[0].size.eql?(exp_val == 0 ? 0 : exp_val - 2)
      if str_val.strip.empty?
        next 
      elsif str_val.strip.eql?('end') || strip_line.first == 'elsif' || strip_line.first == 'when'
        log_error("line:#{indx+1} #{msg}") unless end_chk
      elsif !emp[0].size.eql?(exp_val)
        log_error("line:#{indx+1} #{msg}")
      end
      
      # log_error("line:#{indx} #{msg}") unless emp[0].size.eql?(exp_val)
      # res_word_indent(strip_line, file_arr, indx, msg)
      # res_end_indent(str_val, file_arr, indx, msg)
      # res_do_indent(strip_line, file_arr, indx, msg, indent_reg)
      # res_when_indent(strip_line, file_arr, indx, msg, indent_reg)
      cur_val = indent_val
    end
  end

  def res_word_indent(strip_line, file_arr, indx, msg)
    res_word = %w[class def if elsif until module]
    return unless res_word.include?(strip_line.first) && !file_arr[indx + 1].strip.empty?

    spa = file_arr[indx].match(/^\s*\s*/m)
    reg = /^\s{#{spa[0].size + 2}}\w/
    log_error("line:#{indx + 2} #{msg}") unless file_arr[indx + 1].match?(reg)
    # puts "line #{indx} matched? : #{file_arr[indx + 1].match?(reg)}  size : #{spa[0].size + 2}"
  end

  def res_end_indent(str_val, file_arr, indx, msg)
    return unless str_val.strip == 'end' && !file_arr[indx - 1].strip.empty?

    spa = file_arr[indx].match(/^\s*\s*/)
    reg = /^\s{#{spa[0].size + 2}}\w/
    log_error("line:#{indx} #{msg}") unless file_arr[indx - 1].match?(reg)
  end

  def res_do_indent(strip_line, file_arr, indx, msg, _indent_reg)
    return unless strip_line.include?('do') && !file_arr[indx + 1].strip.empty?

    spa = file_arr[indx].match(/^\s*\s*/)
    reg = /^\s{#{spa[0].size + 2}}\w/
    log_error("line:#{indx + 2} #{msg}") unless file_arr[indx + 1].match?(reg)
  end

  def res_when_indent(strip_line, file_arr, indx, msg, indent_reg)
    return unless strip_line.first.eql?('when') && !strip_line.include?('then') && !file_arr[indx + 1].strip.empty?

    log_error("line:#{indx + 2} #{msg}") unless file_arr[indx + 1].match?(indent_reg)
  end

  def check_tag_error(*args)
    @checker.file_lines.each_with_index do |str_val, index|
      open_p = []
      close_p = []
      open_p << str_val.scan(args[0])
      close_p << str_val.scan(args[1])

      status = open_p.flatten.size <=> close_p.flatten.size

      log_error("line:#{index + 1} Lint/Syntax: Unexpected/Missing token '#{args[2]}' #{args[4]}") if status.eql?(1)
      log_error("line:#{index + 1} Lint/Syntax: Unexpected/Missing token '#{args[3]}' #{args[4]}") if status.eql?(-1)
    end
  end

  def tag_error
    check_tag_error(/\(/, /\)/, '(', ')', 'Parenthesis')
    check_tag_error(/\[/, /\]/, '[', ']', 'Square Bracket')
    check_tag_error(/\{/, /\}/, '{', '}', 'Curly Bracket')
  end

  def end_error
    keyw_count = 0
    end_count = 0
    @checker.file_lines.each_with_index do |str_val, _index|
      keyw_count += 1 if @keywords.include?(str_val.split(' ').first) || str_val.split(' ').include?('do')
      end_count += 1 if str_val.strip == 'end'
    end

    status = keyw_count <=> end_count
    log_error("Lint/Syntax: Missing 'end'") if status.eql?(1)
    log_error("Lint/Syntax: Unexpected 'end'") if status.eql?(-1)
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

    log_error("line:#{indx + 2} #{msg}") if @checker.file_lines[indx + 1].strip.empty?
  end

  def check_def_empty_line(str_val, indx)
    msg1 = 'Extra empty line detected at method body beginning'
    msg2 = 'Use empty lines between method definition'

    return unless str_val.strip.split(' ').first.eql?('def')

    log_error("line:#{indx + 2} #{msg1}") if @checker.file_lines[indx + 1].strip.empty?
    log_error("line:#{indx + 1} #{msg2}") if @checker.file_lines[indx - 1].strip.split(' ').first.eql?('end')
  end

  def check_end_empty_line(str_val, indx)
    return unless str_val.strip.split(' ').first.eql?('end')

    log_error("line:#{indx} Extra empty line detected at block body end") if @checker.file_lines[indx - 1].strip.empty?
  end

  def check_do_empty_line(str_val, indx)
    msg = 'Extra empty line detected at block body beginning'
    return unless str_val.strip.split(' ').include?('do')

    log_error("line:#{indx + 2} #{msg}") if @checker.file_lines[indx + 1].strip.empty?
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
ch.errors.uniq.each { |err| puts err.colorize(:red) }
