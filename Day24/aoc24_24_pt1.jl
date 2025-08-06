# using Pkg
# Pkg.add("Combinatorics")
using Combinatorics

function get_var(input)
    var = Dict()
    missed = []
    for line in input
        if line == ""
            continue
        end
        if occursin("AND", line)
            first_split = split(line, "AND")
            var1 = first_split[1] |> strip
            second_split = split(first_split[2], "->")
            var2 = second_split[1] |> strip
            result = second_split[2] |> strip
            try
                var[result] = var[var1] & var[var2]
            catch
                push!(missed, line)
            end

        elseif occursin("XOR", line)
            first_split = split(line, "XOR")
            var1 = first_split[1] |> strip
            second_split = split(first_split[2], "->")
            var2 = second_split[1] |> strip
            result = second_split[2] |> strip
            try
                var[result] = var[var1] ⊻ var[var2]
            catch
                push!(missed, line)
            end

        elseif occursin("OR", line)
            first_split = split(line, "OR")
            var1 = first_split[1] |> strip
            second_split = split(first_split[2], "->")
            var2 = second_split[1] |> strip
            result = second_split[2] |> strip
            try
                var[result] = var[var1] | var[var2]
            catch
                push!(missed, line)
            end

        else
            variable = split(line, ":")[1] |> strip
            value = split(line, ":")[2] |> strip
            var[variable] = parse(Int, value)
        end
    end
    return var, missed
end

function iterative_input(var, missed)
    if missed == []
        return var
    end
    new_missed = []
    for line in missed 
        if occursin("AND", line)
            first_split = split(line, "AND")
            var1 = first_split[1] |> strip
            second_split = split(first_split[2], "->")
            var2 = second_split[1] |> strip
            result = second_split[2] |> strip
            try
                var[result] = var[var1] & var[var2]
            catch
                push!(new_missed, line)
            end

        elseif occursin("XOR", line)
            first_split = split(line, "XOR")
            var1 = first_split[1] |> strip
            second_split = split(first_split[2], "->")
            var2 = second_split[1] |> strip
            result = second_split[2] |> strip
            try
                var[result] = var[var1] ⊻ var[var2]
            catch
                push!(new_missed, line)
            end

        else
            first_split = split(line, "OR")
            var1 = first_split[1] |> strip
            second_split = split(first_split[2], "->")
            var2 = second_split[1] |> strip
            result = second_split[2] |> strip
            try
                var[result] = var[var1] | var[var2]
            catch
                push!(new_missed, line)
            end
        end
    end
    return iterative_input(var, new_missed)
end

function dict2bin(dict, c)
    # Collect outputs starting with 'z' in the correct order
    z_wires = filter(x -> startswith(x, c), keys(dict))
    z_wires = sort(collect(z_wires))
    output_bits = [dict[wire] for wire in z_wires]

    num = foldl((acc, bit) -> (acc << 1) | bit, reverse(output_bits))
    return num, join(reverse(output_bits))
end

function get_wrong_z(input, indices)
    interesting = Set()
    for line in input
        if occursin(":", line) || line == ""
            continue
        end
        value = split(line, "->")[2] |> strip
        if value in indices
            first = split(line, "->")[1] |> strip
            second_split = split(first, " ")
            push!(interesting, strip(second_split[1]))
            push!(interesting, strip(second_split[end]))

        end
    end
    return interesting
end


function compute_test(input)
    variables, missed = get_var(input)
    variables = iterative_input(variables, missed)

    x_number, x_bit = dict2bin(variables, "x")
    y_number, y_bit = dict2bin(variables, "y")
    z_number, z_bit = dict2bin(variables, "z")
    if z_number - x_number - y_number == 0
        return true
    else
        return false
    end
end

function push_list(list, new_list)
    for item in new_list
        push!(list, item)
    end
    return list
end 

function main()

    input = "input.txt"
    input = readlines(input)
    # println(input)

    variables, missed = get_var(input)
    variables = iterative_input(variables, missed)
    # println(variables)

    x_number, x_bit = dict2bin(variables, "x")
    y_number, y_bit = dict2bin(variables, "y")
    z_number, z_bit = dict2bin(variables, "z")

    # println("Decimal output: ", x_number, " Binary output: ", x_bit)
    # println("Decimal output: ", y_number, " Binary output: ", y_bit)
    # println("Decimal output: ", z_number, " Binary output: ", z_bit)
    # println("Difference: ", bitstring(z_number - x_number - y_number))

    indices = findall(x -> x == '1', reverse(bitstring(z_number - x_number - y_number)))
    z_indices = ["z" * string(num) for num in indices]
    # println("Not correct indices: ", z_indices)

    wrong_z = collect(get_wrong_z(input, z_indices))
    # println("Wrong z: ", wrong_z, " Length: ", length(wrong_z))

    # Filter lines that contain the target strings
    target_lines = [line for line in input if any(contains(line, t) for t in wrong_z)]
    target_lines = [line for line in target_lines if any(contains(split(line, "->")[2], t) for t in wrong_z)]
    # println("Target lines: ", target_lines, " Length: ", length(target_lines))

    # Generate all combinations of 8 elements
    numbers = 1:length(target_lines)
    combs = combinations(numbers, 8)

    for comb in combs
        test_input = [target_lines[i] for i in comb]
        test_z = [split(line, "->")[2] |> strip for line in test_input]
        # println("Testing combination: ", test_input)
        # println("Testing z: ", test_z)

        new_test_input = []
        for i in 1:8
            line = test_input[i][1:end-3]
            if i % 2 == 1
                line *= test_z[i+1]
            else
                line *= test_z[i-1]
            end
            push!(new_test_input, line)
        end

        new_input = []
        new_input = push_list(new_input, input[1:91])
        new_input = push_list(new_input, [line for line in input[92:end] if all(!contains(split(line, "->")[2], t) for t in test_z)])
        new_input = push_list(new_input, new_test_input)

        if compute_test(new_input)
            println("Correct combination: ", comb)
            break
        end
    end




end

main()