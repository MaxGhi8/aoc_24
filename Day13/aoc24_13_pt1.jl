using LinearAlgebra

# Function to extract numbers from a string
function extract_numbers(line::String)
    line = replace(line, " " => "")
    line = split(line, ",")
    X = parse(Int, split(line[1], "+")[2])
    Y = parse(Int, split(line[2], "+")[2])
    return (X, Y)
end

function extract_prize(line::String)
    line = replace(line, " " => "")
    line = split(line, ",")
    X = parse(Int, split(line[1], "=")[2])
    Y = parse(Int, split(line[2], "=")[2])
    return (X, Y)
end

# Open and read the file
filename = "input.txt"  # Replace with the path to your file
button_a_data = []
button_b_data = []
prize_data = []

for line in readlines(filename)
    if occursin("Button A", line)
        push!(button_a_data, extract_numbers(line))
    elseif occursin("Button B", line)
        push!(button_b_data, extract_numbers(line))
    elseif occursin("Prize", line)
        push!(prize_data, extract_prize(line))
    else
        continue
    end
end

# Output the extracted data for verification
# println("Button A Data: ", button_a_data)
# println("Button B Data: ", button_b_data)
# println("Prize Data: ", prize_data)


# Define a function to calculate the minimal tokens needed
function is_approx_int(x)
    return abs(x - Int(round(x))) < 1e-6
end


cost_a = 3
cost_b = 1
function find_min_tokens(button_a, button_b, prize)
    # Define the coefficient matrix and the prize position vector
    ax, ay = button_a
    bx, by = button_b
    px, py = prize

    A = [ax bx; ay by]
    b = [px; py]

    # Solve the integer linear system
    try
        x = A\b
        
        # Ensure solutions are integers
        if (is_approx_int(x[2])) && (is_approx_int(x[1])) && all(x .>= 0)
            num_a = Int(round(x[1]))
            num_b = Int(round(x[2]))

            # Calculate the total cost
            total_cost = num_a * cost_a + num_b * cost_b
            return total_cost
        else
            return 0 # No solution
        end
    catch
        return 0 # No solution (matrix not invertible)
    end
end


println(sum(find_min_tokens.(button_a_data, button_b_data, prize_data)))
