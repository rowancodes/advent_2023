input = File.read("input.txt")
input = input.split("\n")

# sevenine should be "79" and not "7ine" so this is the best solution
$word_to_number = {
    "one" => "o1e",
    "two" => "t2o",
    "three" => "t3e",
    "four" => "f4r",
    "five" => "f5e",
    "six" => "s6x",
    "seven" => "s7n",
    "eight" => "e8t",
    "nine" => "n9e",
}

$re = Regexp.new($word_to_number.keys.map { |x| Regexp.escape(x) }.join('|'))

def translate(line)
    result = line
    2.times do
        result = result.gsub($re, $word_to_number)
    end
    result
end

calibration = input.map { |line| 
    translated = translate(line)
    nums = translated.gsub(/\D/, "").split("")
    result = "#{nums.first}#{nums.last}".to_i
    p "#{line} => #{translated} => #{nums} => #{result}"

    result
}

p calibration.sum