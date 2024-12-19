function can_construct_design(design, patterns, memo)
    # Base case: If the design is empty, it's constructible
    if design == ""
        return true
    end

    # Check memoization to avoid recalculating
    if haskey(memo, design)
        return memo[design]
    end

    # Try matching the beginning of the design with each pattern
    for pattern in patterns
        if startswith(design, pattern)
            # If the pattern matches the beginning, recurse on the remainder
            remainder = design[length(pattern)+1:end]
            if can_construct_design(remainder, patterns, memo)
                memo[design] = true
                return true
            end
        end
    end

    # If no patterns work, it's not constructible
    memo[design] = false
    return false
end

function count_constructible_designs(patterns, designs)
    # Prepare a memoization dictionary
    memo = Dict{String, Bool}()

    # Count the number of designs that can be constructed
    count = 0
    for design in designs
        if can_construct_design(design, patterns, memo)
            count += 1
        end
    end
    return count
end


function main()
    input = "input.txt"
    input = readlines(input)
    patterns = split(input[1], ',')
    patterns = strip.(patterns, ' ')
    designs = input[3:end]
    # println("patterns:", patterns)
    # println("designs:", designs)
    result = count_constructible_designs(patterns, designs)
    println("Number of constructible designs: $result")
end

main()
