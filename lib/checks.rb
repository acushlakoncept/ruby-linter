require 'colorize'
require_relative 'file_reader.rb'

class CheckError
  attr_reader :checker
  attr_accessor :errors

  

  def initialize(file_path)
    @checker = FileReader.new(file_path)
    @errors = []
  end

  def check_trailing_spaces
    @checker.file_lines.each_with_index do |str_val, index|
      if str_val[-2] == ' '
        @errors << "line:#{index + 1}:#{str_val.size-1}: Error: Trailing whitespace detected. '#{str_val.gsub(/\s*$/, "_")}' "
      end 
    end
  end

  # def check_indentation(file_lines)
  #   bank = ['class']
  #   file_lines.each_with_index do |str_val, index|
  #     re = /^\w|^  /
  #     # puts "Error found" if re.match(str_val)
  #     puts str_val, index
  #   end
  # end


end

ch = CheckError.new('bug.rb')
ch.check_trailing_spaces
ch.errors.each{ |err| puts err.colorize(:red) }

