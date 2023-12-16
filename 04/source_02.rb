class ScratchOffCard
    attr_accessor :winning_numbers, :scratch_offs, :card_number, :card_count
    def initialize(card, card_number)
        parsed_input = parse_line(card)
        @card_number = card_number
        @winning_numbers = parsed_input[:winning_numbers]
        @scratch_offs = parsed_input[:scratch_offs]
        @card_count = 1
    end

    def parse_line(card)
        (winning_numbers, scratch_offs) = card.split(": ").last.split(" | ")
        winning_numbers = winning_numbers.split(" ")
        scratch_offs = scratch_offs.split(" ")
        return { :winning_numbers => winning_numbers, :scratch_offs => scratch_offs }
    end

    def matching_numbers_count
        matching_values_count = (winning_numbers & scratch_offs).count
    end

    def raise_card_count
        @card_count += 1
    end
end

$all_scratch_cards = []

def parse_input
    input = File.read("input.txt")
    input = input.split("\n")
    input
end

def generate_duplicates_for(winning_card, matching_numbers_count)
    current_card_number = winning_card.card_number
    range = (current_card_number+1..current_card_number+matching_numbers_count)
    range.each do |num|
        next_card = $all_scratch_cards.select { |card| card.card_number == num}.first
        (winning_card.card_count).times do
            next_card.raise_card_count
        end
    end
end

parse_input.each_with_index do |line, index|
    $all_scratch_cards.push(ScratchOffCard.new(line, index+1))
end

total_card_number = 0

$all_scratch_cards.each do |card|
    matching_numbers_count = card.matching_numbers_count
    generate_duplicates_for(card, matching_numbers_count)
    total_card_number += card.card_count
end

p total_card_number