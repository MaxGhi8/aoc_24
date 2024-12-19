function count_ways_to_construct(design, patterns, memo)
    # Base case: If the design is empty, there's exactly one way to construct it (do nothing)
    if design == ""
        return 1
    end

    # Check memoization to avoid redundant calculations
    if haskey(memo, design)
        return memo[design]
    end

    # Initialize the count of ways to construct the design
    total_ways = 0

    # Try matching the beginning of the design with each pattern
    for pattern in patterns
        if startswith(design, pattern)
            # If the pattern matches, recursively count the ways for the remainder
            remainder = design[length(pattern)+1:end]
            total_ways += count_ways_to_construct(remainder, patterns, memo)
        end
    end

    # Store the result in memoization dictionary
    memo[design] = total_ways
    return total_ways
end

function count_constructible_designs(patterns, designs)
    # Prepare a memoization dictionary
    memo = Dict{String, Int}()

    # Count the number of designs that can be constructed
    tot_count = 0
    for design in designs
        tot_count += count_ways_to_construct(design, patterns, memo) 
    end
    return tot_count
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
