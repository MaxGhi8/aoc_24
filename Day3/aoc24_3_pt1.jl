lines = readlines("input.txt")

function extract_and_sum_multiplications(input)::Int
    # Regex to match valid mul(X,Y) instructions where X and Y are 1-3 digit numbers
    pattern = r"mul\((\d{1,3}),(\d{1,3})\)"
    
    # Find all matches of the pattern in the input string
    matches = eachmatch(pattern, input)
    
    # Extract the numbers from each valid match, calculate the product, and sum them
    total_sum = 0
    for m in matches
        # Extract groups (X and Y) as integers
        x = parse(Int, m.captures[1])
        y = parse(Int, m.captures[2])
        total_sum += x * y
    end
    
    return total_sum
end

result = sum(extract_and_sum_multiplications.(lines))
println(result)