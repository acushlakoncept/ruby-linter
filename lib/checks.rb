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

    @checker.file_lines.each_with_index do |str_val, _index|

      fword = str_val.strip.split(' ')

      if fword.first.eql?("class")
        @errors << "line:#{_index + 2} Extra empty line detected at class body beginning" if @checker.file_lines[_index + 1].strip.empty? 
      end

      if fword.first.eql?("def")
        @errors << "line:#{_index + 2} Extra empty line detected at method body beginning" if @checker.file_lines[_index + 1].strip.empty? 
        @errors << "line:#{_index + 1} Use empty lines between method definition" if @checker.file_lines[_index - 1].strip.split(' ').first.eql?("end")
      end

      if fword.first.eql?("end")
        @errors << "line:#{_index} Extra empty line detected at block body end" if @checker.file_lines[_index - 1].strip.empty? && @checker.file_lines[_index - 2].strip.split(' ').first != "end"
      end

      if fword.include?("do")
        @errors << "line:#{_index + 2} Extra empty line detected at block body beginning" if @checker.file_lines[_index + 1].strip.empty? 
      end

    end

    


  end

end

ch = CheckError.new('bug.rb')
# ch.check_trailing_spaces
# ch.tag_error
# ch.end_error
ch.empty_line_error
ch.errors.each { |err| puts err.colorize(:red) }
