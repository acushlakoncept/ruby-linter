# require 'colorize'

# class CheckError
#   attr_reader :err_msg, :file_lines, :file_lines_count
#   def initialize(file_path)
#     @err_msg = ''

#     begin
#       @file_lines = File.readlines(file_path)
#       @file_lines_count = @file_lines.size
#     rescue StandardError => e
#       @file_lines = []
#       @err_msg = "Check file name or path again\n".colorize(:light_red) + e.to_s.colorize(:red)
#     end

#   end
# end

# check = CheckError.new('records.txt')
# puts check.err_msg
# pp check.file_lines
