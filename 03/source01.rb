class PartNumber
    attr_accessor :number_string, :row_index, :col_index, :valid
    def initialize(number_string:, row_index:, col_index:)
        @number_string = number_string
        @row_index = row_index
        @col_index = col_index
        @valid = nil
    end

    def add_to_string(char)
        @number_string.concat(char)
    end

    def is_touching_symbol?
        col_end_index = self.col_index.to_i + self.number_string.length
        col_begin_index = self.col_index - 1
        row_begin_index = self.row_index - 1
        row_end_index = self.row_index + 1
        $all_symbols.each do |part_symbol|
            if (col_begin_index..col_end_index).include?(part_symbol.col_index) && 
                (row_begin_index..row_end_index).include?(part_symbol.row_index)
                return true
            end
        end
        return false
    end
end

class PartSymbol
    attr_accessor :row_index, :col_index
    def initialize(row_index:, col_index:)
        @row_index = row_index
        @col_index = col_index
    end
end

def is_digit?(char)
    ascii_code = char.ord
    48 <= ascii_code && ascii_code <= 57
end

$all_numbers = []
$all_symbols = []
$reading_number_flag = false

def parse_input
    input = File.read("input.txt")
    input = input.split("\n")
    input.each_with_index do |row, row_index|
        row.each_char.with_index do |char, char_index|
            if !is_digit?(char)
                $reading_number_flag = false
                if char != "."
                    symbol = PartSymbol.new(row_index: row_index, col_index: char_index)
                    $all_symbols.push(symbol)
                end
            elsif $reading_number_flag
                $all_numbers.last.add_to_string(char)
            elsif is_digit?(char)
                $reading_number_flag = true
                number = PartNumber.new(number_string: char.to_s, row_index: row_index, col_index: char_index)
                $all_numbers.push(number)
            end
        end
    end
end

def mark_valid_part_numbers
    $all_numbers.each do |part_number|
        if part_number.is_touching_symbol?
            part_number.valid = true
        else
            part_number.valid = false
        end
    end
end

parse_input
mark_valid_part_numbers

sum = 0
$all_numbers.each do |part_number|
    if part_number.valid == true
        sum += part_number.number_string.to_i
    end
end

p sum