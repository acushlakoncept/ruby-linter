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

  # def check_indentation
  #   reserv_count = 0
  #   c = {}
  #   m = {}
  #   @checker.file_lines.each_with_index do |str_val, index|
  #     m[index + 1] = str_val.scan(/\(/)
  #     # m << str_val.scan(/\(/) if str_val.match?(/\(/)
  #     next unless str_val.strip != '#'

  #     next unless @keywords.include?(str_val.split(' ').first) || @keywords.include?(str_val.split(' ').last)

  #     # puts "#{reserv_count += 1} found : #{str_val.split(' ').first}"
  #     c1 = @keywords.include?(str_val.split(' ').first) ? str_val.split(' ').first : str_val.split(' ').last
  #     @keywords_count[c1] += 1
  #   end
  # end

  # def check_tag_error(tag_open, tag_close)
  #   @checker.file_lines.each_with_index do |str_val, i|
  #     tag_check(tag_open, tag_close, str_val, i)
  #   end
  #   open_t.flatten.size <=> close_t.flatten.size
  # end

  # def tag_check(tag_open, tag_close, line_str, index)
  #   open_reg = /\\#{tag_open}/ #%r{#{tag_open}}
  #   close_reg = /\\#{tag_close}/  #%r{#{tag_close}}
  #   line = []
  #   if line_str.match?(open_reg) || line_str.match?(close_reg)
  #     line << index
  #   end
  #   puts line
  # end

  # def tag_error
  #   status, i, tag_open, tag_close, tag_name  = paren_check
  #   @errors << "#line:#{i} '#{tag_open}' Lint/Syntax: Unexpected token #{tag_name}" if status.eql?(1)
  #   @errors << "#line:#{i} '#{tag_close}' Lint/Syntax: Unexpected token #{tag_name}" if status.eql?(-1)
  # end

  # YOU NEED TO REFACTOR HERE ------------------------------------------
  def paren_check
    @checker.file_lines.each_with_index do |str_val, index|
      open_p = []
      close_p = []
      open_p << str_val.scan(/\(/)
      close_p << str_val.scan(/\)/)

      status = open_p.flatten.size <=> close_p.flatten.size

      @errors << "line:#{index + 1}  Lint/Syntax: Unexpected token '(' Parenthesis" if status.eql?(1)
      @errors << "line:#{index + 1} Lint/Syntax: Unexpected token ')' Parenthesis" if status.eql?(-1)
    end
  end

  def square_bracket_check
    @checker.file_lines.each_with_index do |str_val, index|
      open_p = []
      close_p = []
      open_p << str_val.scan(/\[/)
      close_p << str_val.scan(/\]/)

      status = open_p.flatten.size <=> close_p.flatten.size

      @errors << "line:#{index + 1}  Lint/Syntax: Unexpected token '[' Square bracket" if status.eql?(1)
      @errors << "line:#{index + 1} Lint/Syntax: Unexpected token ']' Square bracket" if status.eql?(-1)
    end
  end


end

ch = CheckError.new('bug.rb')
ch.check_trailing_spaces
# ch.check_indentation
ch.paren_check
ch.square_bracket_check
ch.errors.each { |err| puts err.colorize(:red) }
