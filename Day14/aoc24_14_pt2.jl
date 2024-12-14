function parse_input(input)
    positions = []
    velocities = []

    for line in input
        if isempty(line)
            continue
        end
        # Extract p and v parts
        p_match = match(r"p=(\d+),(\-?\d+)", line)
        v_match = match(r"v=(\-?\d+),(\-?\d+)", line)
        if p_match !== nothing && v_match !== nothing
            push!(positions, [ parse(Int, p_match[2]), parse(Int, p_match[1]) ])
            push!(velocities, [ parse(Int, v_match[2]), parse(Int, v_match[1]) ])
        end
    end
    return positions, velocities
end

function remove_neg(num, row_col)
    return num < 0 ? row_col + num : num
end

function move_robots(pos, vel, time, cols, rows)
    new_pos_list = []
    for (idx, p) in enumerate(pos)
        v = vel[idx]
        tmp = p .+ time.*v
        new_pos = [0, 0]
        new_pos[1] = remove_neg(tmp[1] % (rows), rows)
        new_pos[2] = remove_neg(tmp[2] % (cols), cols)

        push!(new_pos_list, new_pos)
    end
    return new_pos_list
end

function draw_pos(pos, cols, rows)
    grid = [fill(".", cols) for _ in 1:rows]
    for p in pos
        grid[p[1]+1][p[2]+1] = "#" 
    end
    return grid
end

function get_blob(pos, rows, cols)
    pos = Set(pos)
    near = 0
    for i in 1:rows
        for j in 1:cols
            if [i, j] in pos && [i+1, j] in pos && [i-1, j] in pos 
                near += 1
            end
        end
    end
    return near > 100
end
    
function main()
    # read the file
    input = "input.txt"
    input = readlines(input)
    p, v = parse_input(input)
    # println("p: ", p)
    # println("v: ", v)

    # move the robots
    cols = 101
    rows = 103


    for i = 1:10000
        new_p = move_robots(p, v, i, cols, rows)
        if get_blob(new_p, rows, cols)
            new_p = draw_pos(new_p, cols, rows)
            println(i)
            for line in new_p
                println(join(line))
            end
        end
    end

end

main()