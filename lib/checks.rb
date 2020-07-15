require 'colorize'
require_relative 'file_reader.rb'

class CheckError
  attr_reader :checker, :errors
  @errors = []

  def initialize(file_path)
    @checker = FileReader.new(file_path)
  end

  def check_trailing_spaces(file_lines)
    errors = []
    file_lines.each_with_index do |line_content, line_num|
      if line_content[-2] == ' '
        errors << "line:#{line_num}:#{line_content.size-1}: Error: Trailing whitespace detected. '#{line_content.gsub(/\s*$/, "_")}' "
      end 
    end
    errors
  end
end


# if m ? puts m.string : "Nil"
# puts "Nil" unless m 
# puts "#{m.string}" if m

# def trailing_spaces_check(file_lines)
#   file_lines.each_with_index do |line_content, line_num|
#     if line_content[-2] == ' '
#       @errors_list << {line: line_num, error: 'No trailing spaces allowed' } 
#     end 
#   end
# end

ch = CheckError.new('bug.rb')
pp ch.check_trailing_spaces(ch.checker.file_lines)


