class Round
    attr_accessor :game_id
    def initialize(game_id:, red_count: 0, green_count: 0, blue_count: 0)
        @game_id = game_id
        @red_count = red_count.to_i
        @green_count = green_count.to_i
        @blue_count = blue_count.to_i
    end

    def impossible?(max_red:, max_green:, max_blue:)
        max_red < @red_count || max_green < @green_count || max_blue < @blue_count
    end
end 

$all_rounds = []

def parse_input
    input = File.read("input.txt")
    input = input.split("\n")
    games = input.map { |game| 
        game_id = game.split[1].sub(":", "")
        rounds = game.split(": ").unshift[1].split("; ")
        rounds.each { |round|
            blocks = round.split(",")
            round = blocks.map { |set|
                post_split = set.split
                {post_split.last => post_split.first}
            }
            
            round = round.reduce(:merge)

            $all_rounds.push(
                    Round.new(
                        game_id: game_id, 
                        red_count: round["red"],
                        green_count: round["green"],
                        blue_count: round["blue"],
                    )
            )
        }
    }
end

parse_input

impossible_game_ids = []
$all_rounds.each { |round|
    p round
    if round.impossible?(max_red: 12, max_green: 13, max_blue: 14)
        impossible_game_ids.push(round.game_id.to_i)
        puts "IMPOSSIBLE"
    end
}

possible_game_ids =  (Array(1..100) - impossible_game_ids.uniq)

p possible_game_ids.sum