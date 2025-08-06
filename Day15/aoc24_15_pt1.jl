function parse_input(grid::Vector{String})
    # Part 1: Parse the grid for positions of '#', 'O', '@'
    positions = Dict('#' => [], 'O' => [], '@' => (0, 0))
    for (row_idx, row) in enumerate(grid)
        for (col_idx, char) in enumerate(row)
            if char in keys(positions)
                if char == '@'
                    positions[char] = (row_idx, col_idx)
                else
                    push!(positions[char], (row_idx, col_idx))
                end
            end
        end
    end

    return positions
end


const dict_moves = Dict('^' => (-1, 0), 'v' => (1, 0), '<' => (0, -1), '>' => (0, 1))

function make_move(grid, move)
    # get the new position
    dir = dict_moves[move]
    current_pos = grid['@']
    new_pos = current_pos .+ dir

    # if there is an obstacle do nothing
    if new_pos in grid['#']
        return grid
    # if there is a box
    elseif new_pos in grid['O']
        # check if I can move the box
        can_move = true
        tmp_pos = new_pos
        while true
            tmp_pos = tmp_pos.+ dir
            if tmp_pos in grid['#']
                can_move = false
                break
            elseif tmp_pos in grid['O']
                continue
            else
                break
            end
        end

        # move the box if I can move
        if can_move
            grid['@'] = new_pos
            filter!(x -> x != new_pos, grid['O']) # delete the first O
            while true
                new_pos = new_pos.+ dir
                if new_pos in grid['O']
                    continue
                else
                    push!(grid['O'], new_pos)
                    break
                end
            end
            return grid
        # Do nothing if I can't move
        else
            return grid
        end

    # if there is nothing just move
    else
        grid['@'] = new_pos
        return grid
    end
end

function main()
    input = readlines("input.txt")
    split_index = findfirst(==(""), input)

    grid = input[1:split_index-1]
    grid = parse_input(grid)
    # println(grid)

    moves = join(input[split_index+1:end])
    # println(moves)

    for move in moves
        grid = make_move(grid, move)
    end
    # println(grid)

    tot = 0
    for pos in grid['O']
        tot += (pos[1]-1)*100 + (pos[2]-1)
    end
    println(tot)
end

main()