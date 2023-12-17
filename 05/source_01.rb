$all_seeds = []
$all_mappings = []
$mapping_names = []

class Map
    attr_accessor :name, :destination_range_start, :source_range_start, :length
    def initialize(name:, destination:, source:, length:)
        @name = name
        @destination_range_start = destination.to_i
        @source_range_start = source.to_i
        @length = length.to_i
    end
end

def parse_input
    input = File.read("input.txt")
    input = input.split("\n")
    $all_seeds = input.shift.split("seeds: ").last.split(" ")

    map_name = nil
    until input.empty?
        current_line = input.shift
        if current_line.empty?                                  # new-line
            map_name = nil
        elsif current_line.match(/\d/).nil?                     # current line doesnt contain numbers
            map_name = current_line.split.first
            $mapping_names.push(map_name)
        else                                                    # numbers
            values = current_line.split
            mapping = Map.new(name: map_name, destination: values[0], source: values[1], length: values[2])
            $all_mappings.push(mapping)
        end 
    end
end

def find_value_for(key, mapping_name)
    $all_mappings.each do |mapping|
        next if mapping.name != mapping_name

        destination_range = (mapping.destination_range_start...mapping.destination_range_start+mapping.length)
        source_range = (mapping.source_range_start...mapping.source_range_start+mapping.length)
        
        if source_range.include?(key)
            return (mapping.destination_range_start + (key - mapping.source_range_start))
        end
    end
    return key # no key found for map name
end

def find_location_from_seed(seed)
    current_key = seed.to_i
    $mapping_names.each do |name|
        current_key = find_value_for(current_key, name)
    end
    current_key
end

parse_input

lowest_location_value = nil
$all_seeds.each do |seed|
    location = find_location_from_seed(seed)
    lowest_location_value = location if (lowest_location_value.nil? || location < lowest_location_value)
end

p lowest_location_value