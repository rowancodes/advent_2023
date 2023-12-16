class ScratchOffCard
    attr_accessor :winning_numbers, :scratch_offs
    def initialize(card)
        parsed_input = parse_line(card)
        @winning_numbers = parsed_input[:winning_numbers]
        @scratch_offs = parsed_input[:scratch_offs]
    end

    def parse_line(card)
        (winning_numbers, scratch_offs) = card.split(": ").last.split(" | ")
        winning_numbers = winning_numbers.split(" ")
        scratch_offs = scratch_offs.split(" ")
        return { :winning_numbers => winning_numbers, :scratch_offs => scratch_offs }
    end

    def score
        matching_values_count = (winning_numbers & scratch_offs).count
        return 2**(matching_values_count-1) if matching_values_count > 0
        return 0
    end
end

def parse_input
    input = File.read("input.txt")
    input = input.split("\n")
    input
end

total_score = 0

parse_input.each do |line|
    total_score += ScratchOffCard.new(line).score
end

p total