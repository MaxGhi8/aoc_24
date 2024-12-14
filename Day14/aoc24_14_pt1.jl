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

function count_robots(pos, rows, cols)
    mid = [rows÷2, cols÷2]
    count = [0, 0, 0, 0]
    for p in pos
        if p[1] < mid[1] && p[2] < mid[2]
            count[1] += 1
        elseif p[1] < mid[1] && p[2] > mid[2]
            count[2] += 1
        elseif p[1] > mid[1] && p[2] < mid[2]
            count[3] += 1
        elseif p[1] > mid[1] && p[2] > mid[2]
            count[4] += 1
        end
    end
    return count[1]*count[2]*count[3]*count[4] 
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
    time = 100
    new_p = move_robots(p, v, time, cols, rows)
    # println("new_p: ", new_p)

    # count the robots
    count = count_robots(new_p, rows, cols)
    println("count: ", count)

end

main()