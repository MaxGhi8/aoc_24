function widen_warehouse_map(map::Vector{String})
    # Initialize an empty vector to store the new wider map
    wider_map = Vector{String}()
    
    # Iterate through each row in the original map
    for row in map
        # Initialize an empty string for the new wider row
        new_row = ""
        
        # Process each character in the row
        for tile in row
            if tile == '#'
                new_row *= "##"  # Replace # with ##
            elseif tile == 'O'
                new_row *= "[]"  # Replace O with []
            elseif tile == '.'
                new_row *= ".."  # Replace . with ..
            elseif tile == '@'
                new_row *= "@."  # Replace @ with @.
            else
                new_row *= tile  # Keep other characters as is
            end
        end
        
        # Append the new wider row to the wider map
        push!(wider_map, new_row)
    end
    
    return wider_map
end

function parse_input(grid::Vector{String})
    # Part 1: Parse the grid for positions of '#', 'O', '@'
    positions = Dict('#' => [], '[' => [], ']' => [], '@' => (0, 0))
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
    elseif new_pos in grid['['] || new_pos in grid[']']
        #### horizontal move
        if move in "<>"
            # check if I can move the box
            can_move = true
            tmp_pos = new_pos
            box2move = Set()
            while true
                if tmp_pos in grid['#']
                    can_move = false
                    break
                elseif tmp_pos in grid['['] || tmp_pos in grid[']']
                    push!(box2move, tmp_pos)
                    tmp_pos = tmp_pos .+ dir
                else
                    break
                end
            end

            # move the box if I can move
            if can_move
                grid['@'] = new_pos
                for box in box2move
                    new_box = box .+ dir
                    if box in grid['[']
                        filter!(x -> x != box, grid['[']) # delete the box
                        push!(grid['['], new_box)
                    else
                        filter!(x -> x != box, grid[']']) # delete the box
                        push!(grid[']'], new_box)
                    end
                end
                return grid
            # Do nothing if I can't move
            else
                return grid
            end

        #### vertical move
        else
            can_move = true
            tmp_pos = new_pos

            box2move = Vector() # store all the boxes to move
            boxes = Set() # store the boxes in the current line
            push!(boxes, tmp_pos) # add the new_pos
            # add the associated closing bracket
            if tmp_pos in grid['[']
                push!(boxes, (tmp_pos[1], tmp_pos[2]+1))
            else
                push!(boxes, (tmp_pos[1], tmp_pos[2]-1))
            end
            push!(box2move, boxes)
            while true
                boxes = Set()
                for bracket_pos in box2move[end]
                    new_br_pos = bracket_pos .+ dir
                    if new_br_pos in grid['#']
                        can_move = false
                        break
                    elseif new_br_pos in grid['[']
                        push!(boxes, new_br_pos)
                        push!(boxes, (new_br_pos[1], new_br_pos[2]+1))
                    elseif new_br_pos in grid[']']
                        push!(boxes, new_br_pos)
                        push!(boxes, (new_br_pos[1], new_br_pos[2]-1))
                    end
                end
                if can_move
                    if length(boxes) == 0
                        break
                    else
                        push!(box2move, boxes)
                    end
                else
                    break
                end
            end

            # move the box if I can move
            if can_move
                grid['@'] = new_pos
                for line in box2move, box in line
                    if box in grid['[']
                        filter!(x -> x != box, grid['[']) # delete the box
                        push!(grid['['], box .+ dir)
                    else
                        filter!(x -> x != box, grid[']']) # delete the box
                        push!(grid[']'], box .+ dir)
                    end
                end
                return grid
            else
                return grid
            end

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
    grid = widen_warehouse_map(grid)
    rows = length(grid)
    cols = length(grid[1])
    grid = parse_input(grid)
    # println(grid)

    moves = join(input[split_index+1:end])
    # println(moves)

    for move in moves
        grid = make_move(grid, move)
    end
    println(grid)

    tot = 0
    for pos in grid['[']
        left = pos[2] - 1
        right = cols - pos[2] - 1
        top = pos[1] - 1
        bottom = rows - pos[1] - 1

        tot += min(top, bottom)*100 + min(left, right)
    end
    println(tot)
end

main()