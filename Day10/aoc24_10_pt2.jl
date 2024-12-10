input = "input.txt"
input = readlines(input)
input = [map(x -> parse(Int, x), collect(num)) for num in input]
const rows = length(input)
const cols = length(input[1])

function zero_position(input)
    zero_positions = []
    for r in 1:rows
        for c in 1:cols
            if input[r][c] == 0
                push!(zero_positions, [(r, c)])
            end
        end
    end 
    return zero_positions 
end

function find_path(input, path, num)
    # end of recursion
    if num == 9 
        return path
    end
    # recursive step
    new_path = []
    for p in path
        (r, c) = p[end]
        if (r-1 >= 1) && (input[r-1][c] == num+1)
            push!(new_path, cat(p, [(r-1, c)], dims=1))
        end
        if (r+1 <= rows) && (input[r+1][c] == num+1)
            push!(new_path, cat(p, [(r+1, c)], dims=1))
        end
        if (c-1 >= 1) && (input[r][c-1] == num+1)
            push!(new_path, cat(p, [(r, c-1)], dims=1))
        end
        if (c+1 <= cols) && (input[r][c+1] == num+1)
            push!(new_path, cat(p, [(r, c+1)], dims=1))
        end
    end
    
    return find_path(input, new_path, num+1)
end

function main()
    # for line in input
    #     println(line)
    # end 
    zero_positions = zero_position(input)
    # println("Zero position: ", zero_positions)
    pathes = find_path(input, zero_positions, 0)

    set = Set()
    for path in pathes
        if length(path) == 10
            push!(set, path)
        end
    end
    println(length(set))
end

main()



