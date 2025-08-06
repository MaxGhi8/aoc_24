
function initial_conversion(input)
    new_input = []
    for line in input
        push!(new_input, "A"*line)
    end
    return new_input
end

function best_path(x, y, dx, dy, robots, invalid)
    ret = nothing
    queue = [(x, y, "")]

    while !isempty(queue)
        (x, y, path) = popfirst!(queue)

        if x == dx && y == dy
            temp = best_robot(path * "A", robots - 1)
            ret = isnothing(ret) ? temp : min(ret, temp)
        elseif (x, y) != invalid
            if x < dx
                push!(queue, (x + 1, y, path * ">"))
            elseif x > dx
                push!(queue, (x - 1, y, path * "<"))
            end
            if y < dy
                push!(queue, (x, y + 1, path * "v"))
            elseif y > dy
                push!(queue, (x, y - 1, path * "^"))
            end
        end
    end

    return ret
end

function best_robot(path, robots)
    if robots == 1
        return length(path)
    end

    ret = 0
    pad = decode_pad("X^A<v>", 3)
    x, y = pad["A"]

    for val in path
        dx, dy = pad[val]
        ret += best_path(x, y, dx, dy, robots, pad["X"])
        x, y = dx, dy
    end

    return ret
end

function decode_pad(val, width)
    ret = Dict{Char, Tuple{Int, Int}}()
    for (x, char) in enumerate(val)
        ret[char] = ((x - 1) % width, (x - 1) ÷ width)
    end
    return ret
end

function cheapest(x, y, dx, dy, robots, invalid)
    ret = nothing
    todo = [(x, y, "")]

    while !isempty(todo)
        (x, y, path) = popfirst!(todo)

        if x == dx && y == dy
            temp = best_robot(path * "A", robots)
            ret = isnothing(ret) ? temp : min(ret, temp)
        elseif (x, y) != invalid
            if x < dx
                push!(todo, (x + 1, y, path * ">"))
            elseif x > dx
                push!(todo, (x - 1, y, path * "<"))
            end
            if y < dy
                push!(todo, (x, y + 1, path * "v"))
            elseif y > dy
                push!(todo, (x, y - 1, path * "^"))
            end
        end
    end

    return ret
end

function calc(values, mode)
    ret = 0
    pad = decode_pad("789456123X0A", 3)

    for row in values
        result = 0
        x, y = pad['A']
        for val in row
            dx, dy = pad[val]
            result += cheapest(x, y, dx, dy, mode == 1 ? 3 : 26, pad['X'])
            x, y = dx, dy
        end
        multiplier = parse(Int, lstrip(row[1:end-1], '0'))
        ret += result * multiplier
    end

    return ret
end

function test()
    values = readlines("input.txt")

    println(calc(values, 1))
    # log.test(calc(log, values, 2), "TODO")
end

test()


function main()
    input = readlines("input.txt")
    # println(input)
    new_input = initial_conversion(input)
    # println(new_input)



    total_len = 0
    number = [965, 143, 528, 670, 973]
    # number = [29, 980, 179, 456, 379]
    for (idx, s) in enumerate(final_robot)
        total_len += length(s)*number[idx]
        println(length(s))
    end

    println(total_len)


end

main()
