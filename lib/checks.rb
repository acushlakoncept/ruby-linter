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
    @keywords = ["begin","case","class","def","do","if","module", "unless"]
    @keywords_count = {}
    @keywords.each {|val| @keywords_count[val] = 0}
    @matched = []
  end

  def check_trailing_spaces
    @checker.file_lines.each_with_index do |str_val, index|
      if str_val[-2] == ' '
        @errors << "line:#{index + 1}:#{str_val.size-1}: Error: Trailing whitespace detected. '#{str_val.gsub(/\s*$/, "_")}' "
      end 
    end
  end

  def check_indentation
    reserv_count = 0
    c = {}
    m = {}
    @checker.file_lines.each_with_index do |str_val, index|
      m[index+1] = str_val.scan(/\(/)
      # m << str_val.scan(/\(/) if str_val.match?(/\(/)
      if str_val.strip != '#'
        if @keywords.include?(str_val.split(' ').first) || @keywords.include?(str_val.split(' ').last)
          # puts "#{reserv_count += 1} found : #{str_val.split(' ').first}"
         c1 = @keywords.include?(str_val.split(' ').first) ? str_val.split(' ').first : str_val.split(' ').last
         @keywords_count[c1] += 1
        end
      
      end
      
    end
    # puts @keywords_count
    # p m.each_value{|x| x=='('}
  end

  def check_tag_error(tag_open, tag_close)
    @checker.file_lines.each_with_index do |str_val, i|
      tag_check(tag_open, tag_close, str_val, i)
    end
    open_t.flatten.size <=> close_t.flatten.size
  end

  def tag_check(tag_open, tag_close, line_str, index)
    open_reg = /\\#{tag_open}/ #%r{#{tag_open}} 
    close_reg = /\\#{tag_close}/  #%r{#{tag_close}}
    line = []
    if line_str.match?(open_reg) || line_str.match?(close_reg) 
      line << index
    end
    # node = Parser::Ruby24.parse(line_str)
    # @open_t << line_str.scan(%r{\\#{tag_open}})
    # @close_t << line_str.scan(%r{\\#{tag_close}})
    # open_t.flatten.size <=> close_t.flatten.size
    # line.last
    puts line
  end

  def tag_error
    status, i, tag_open, tag_close, tag_name  = paren_check
    @errors << "#line:#{i} '#{tag_open}'' Error: Opening #{tag_name} missing" if status.eql?(1)
    @errors << "#line:#{i} '#{tag_close}'' Error: Closing #{tag_name} missing" if status.eql?(-1)
  end

  def paren_check
    line = []
    open_p = []
    close_p = []
    @checker.file_lines.each_with_index do |str_val, index|
      line << index + 1 if str_val.match?(/\(/) || str_val.match?(/\)/)
      open_p << str_val.scan(/\(/)
      close_p << str_val.scan(/\)/)
    end
    [open_p <=> close_p, line.last, '(', ')', 'Parenthesis']
  end

  
end

ch = CheckError.new('bug.rb')
# ch.check_trailing_spaces
# ch.check_indentation
ch.tag_error
p ch.errors.each{ |err| puts err.colorize(:red) }

