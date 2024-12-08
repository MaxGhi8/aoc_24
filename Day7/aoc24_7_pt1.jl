# Parse input function
function parse_input(lines)
    equations = []
    for line in lines
        target, numbers = split(line, ": ")
        push!(equations, (parse(Int, target), parse.(Int, split(numbers, " "))))
    end
    return equations
end

input = "input.txt"
input = parse_input(readlines(input))

function generate_strings_recursive(n::Int, current::String="")
    if n == 0
        return [current]
    end

    # Add '+' or '*' and recurse
    return generate_strings_recursive(n - 1, current * "+") ∪
           generate_strings_recursive(n - 1, current * "*")

end

function evaluate_expression(numbers)
    target = numbers[1]
    Ls = numbers[2][2:end]
    tot = numbers[2][1]
    tot_op = length(Ls)
    operators = generate_strings_recursive(tot_op)
    for operator in operators
        for (idx, el) in enumerate(operator)
            if el == '+'
                tot += Ls[idx]
            elseif el == '*'
                tot *= Ls[idx]
            end
        end
        if tot == target
            return true
        else
            tot = numbers[2][1]
        end
    end
    return false
end

# filter the correct expressions
println(sum( [el[1] for el in input if evaluate_expression(el)] ))