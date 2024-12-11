function Solve(input, steps)
    input = parse.(Int, split(input, " "))
    current_count = Dict{Int, Int}()
    for value in input
        current_count[value] = 1 + get(current_count, value, 0)
    end

    for _ = 1:steps
        new_count = Dict{Int, Int}()
        for (value, count) in current_count

            if value == 0
                # Rule 1: Replace 0 with 1
                new_count[1] = get(new_count, 1, 0) + count
            elseif length(string(value)) % 2 == 0
                # Rule 2: Even number of digits, split into two stones
                half = div(length(string(value)), 2)
                left = parse(Int, string(value)[1:half])
                right = parse(Int, string(value)[half+1:end])
                new_count[left] = get(new_count, left, 0) + count
                new_count[right] = get(new_count, right, 0) + count
            else
                # Rule 3: Multiply by 2024
                new_count[value * 2024] = get(new_count, value * 2024, 0) + count
            end

        end
        current_count = new_count
    end
    sum(values(current_count))
end


InputString = read("input.txt", String)
println("Part 2: ", Solve(InputString, 75))