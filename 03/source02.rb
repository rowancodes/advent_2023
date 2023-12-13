class PartNumber
    attr_accessor :number_string, :row_index, :col_index
    def initialize(number_string:, row_index:, col_index:)
        @number_string = number_string
        @row_index = row_index
        @col_index = col_index
    end

    def add_to_string(char)
        @number_string.concat(char)
    end

    def is_touching_gear?(part_symbol)
        col_end_index = self.col_index.to_i + self.number_string.length
        col_begin_index = self.col_index - 1
        row_begin_index = self.row_index - 1
        row_end_index = self.row_index + 1
        if (col_begin_index..col_end_index).include?(part_symbol.col_index) && 
            (row_begin_index..row_end_index).include?(part_symbol.row_index)
            part_symbol.touching_part_numbers += 1
            part_symbol.gear_ratio *= self.number_string.to_i
            return true
        end
        return false
    end
end

class PartSymbol
    attr_accessor :part_string, :row_index, :col_index, :touching_part_numbers, :gear_ratio
    def initialize(part_string:, row_index:, col_index:)
        @part_string = part_string
        @row_index = row_index
        @col_index = col_index
        @touching_part_numbers = 0
        @gear_ratio = 1
    end
end

def is_digit?(char)
    ascii_code = char.ord
    48 <= ascii_code && ascii_code <= 57
end

$all_numbers = []
$all_symbols = []
$potential_gears = []
$reading_number_flag = false

def parse_input
    input = File.read("input.txt")
    input = input.split("\n")
    input.each_with_index do |row, row_index|
        row.each_char.with_index do |char, char_index|
            if !is_digit?(char)
                $reading_number_flag = false
                if char != "."
                    symbol = PartSymbol.new(part_string: char.to_s, row_index: row_index, col_index: char_index)
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

parse_input

$all_symbols.each do |part_symbol|
    $potential_gears.push(part_symbol) if part_symbol.part_string == "*"
end

gear_ratio_sum = 0
$potential_gears.each { |part_symbol|
    $all_numbers.each { |part_number|
        part_number.is_touching_gear?(part_symbol)
    }
    gear_ratio_sum += part_symbol.gear_ratio if part_symbol.touching_part_numbers == 2
}

p gear_ratio_sum