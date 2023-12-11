class Round
    attr_accessor :game_id, :red_count, :green_count, :blue_count
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

games = []
100.times do |i|
    games.push({id: i+1, min_red: 0, min_green: 0, min_blue: 0})
end

$all_rounds.each { |round|
    game = games.find {|game| game[:id] == round.game_id.to_i}
    game[:min_red] = round.red_count if round.red_count > game[:min_red]
    game[:min_green] = round.green_count if round.green_count > game[:min_green]
    game[:min_blue] = round.blue_count if round.blue_count > game[:min_blue]
}

sum = 0
games.each { |game|
    sum += game[:min_red] * game[:min_green] * game[:min_blue]
}

p sum