input = File.read("input.txt")
input = input.split("\n")
calibration = input.map { |line| 
    nums = line.gsub(/\D/, "").split("")
    result = "#{nums.first}#{nums.last}".to_i
}

p calibration
p calibration.sum