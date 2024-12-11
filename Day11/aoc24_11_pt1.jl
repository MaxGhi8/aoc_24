input = "input.txt"
input = readlines(input)[1]
input = parse.(Int, split(input, " "))

function process_stones(stones, current_i, final_i)
    if current_i == final_i
        return stones
    end
    new_stones = []

    for stone in stones
        if stone == 0
            # Rule 1: Replace 0 with 1
            push!(new_stones, 1)
        elseif length(string(stone)) % 2 == 0
            # Rule 2: Even number of digits, split into two stones
            half = div(length(string(stone)), 2)
            left = parse(Int, string(stone)[1:half])
            right = parse(Int, string(stone)[half+1:end])
            push!(new_stones, left)
            push!(new_stones, right)
        else
            # Rule 3: Multiply by 2024
            push!(new_stones, stone * 2024)
        end
    end

    return process_stones(new_stones, current_i + 1, final_i)
end

println("Initial stones: ", input)
println("processed stones: ", length(process_stones(input, 0, 75)))
