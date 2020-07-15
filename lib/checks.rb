require 'colorize'
require_relative 'file_reader.rb'

class CheckError
  attr_reader :checker
  attr_accessor :errors

  

  def initialize(file_path)
    @checker = FileReader.new(file_path)
    @errors = []
  end

  def check_trailing_spaces(file_lines)
    file_lines.each_with_index do |str_val, index|
      if str_val[-2] == ' '
        @errors << "line:#{index + 1}:#{str_val.size-1}: Error: Trailing whitespace detected. '#{str_val.gsub(/\s*$/, "_")}' "
      end 
    end
  end
end

ch = CheckError.new('bug.rb')
ch.check_trailing_spaces(ch.checker.file_lines)
ch.errors.each{ |err| puts err.colorize(:red) }


