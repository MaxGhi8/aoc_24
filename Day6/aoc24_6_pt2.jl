# Parse the input map into a grid
map_lines = readlines("input.txt")
grid = [collect(line) for line in map_lines]

# Dimensions of the grid
rows, cols = length(grid), length(grid[1])

# Find the guard's starting position and facing direction
function find_guard(grid)
    for r in 1:rows
        for c in 1:cols
            if grid[r][c] in ['^', 'v', '<', '>']
                return (r, c), grid[r][c]
            end
        end
    end
end

# Find all the obstacle positions
function find_obstacles(grid)
    ls = Dict()
    for r in 1:rows
        for c in 1:cols
            if grid[r][c] == '#'
                ls[(r, c)] = ""
            end
        end
    end
    return ls
end

(start_pos, start_dir) = find_guard(grid)
obstacles = find_obstacles(grid)


directions = Dict('^' => (-1, 0), 'v' => (1, 0), '<' => (0, -1), '>' => (0, 1))
turn_right = Dict('^' => '>', '>' => 'v', 'v' => '<', '<' => '^')
function simulate_guard(grid, start_pos, start_dir)
    visited = Set{Tuple{Int, Int}}()
    pos = start_pos
    dir = start_dir

    while true
        # Mark current position as visited
        push!(visited, pos)

        # Calculate the next position
        delta = directions[dir]
        next_pos = (pos[1] + delta[1], pos[2] + delta[2])

        # Stop if the guard moves out of bounds
        if !(1 <= next_pos[1] <= rows && 1 <= next_pos[2] <= cols)
            break
        end

        # Check if next position is valid and not an obstacle
        if grid[next_pos[1]][next_pos[2]] != '#'
            pos = next_pos  # Move forward
        else
            dir = turn_right[dir]  # Turn right
        end

    end
    return visited
end

visited_positions = simulate_guard(grid, start_pos, start_dir)

function count_loop(grid, start_pos, start_dir, visited_positions)
    count_loop = 0
    for i in 1:rows
        for j in 1:cols
            if grid[i][j] == start_dir || grid[i][j] == '#' 
                continue
            elseif (i, j) in visited_positions
                grid[i][j] = '#'
            else
                continue
            end

            pos = start_pos
            dir = start_dir
            visited = Set([pos[1], pos[2], dir])

            while true
                # Calculate the next position
                delta = directions[dir]
                next_pos = (pos[1] + delta[1], pos[2] + delta[2])

                # Stop if the guard moves out of bounds
                if !(1 <= next_pos[1] <= rows && 1 <= next_pos[2] <= cols)
                    grid[i][j] = '.'
                    break
                end

                # Check if next position is valid and not an obstacle
                if grid[next_pos[1]][next_pos[2]] != '#'
                    pos = next_pos  # Move forward
                    # Check if it is a loop
                    if [pos[1], pos[2], dir] in visited
                        count_loop += 1
                        grid[i][j] = '.'
                        break
                    end
                    # add the new position and direction (for loops) to the visited set
                    push!(visited, [pos[1], pos[2], dir])
                else
                    dir = turn_right[dir]  # Turn right
                end

            end
        end
    end
    return count_loop
end


# Output the number of distinct positions visited

println("Number of possible loops:", count_loop(grid, start_pos, start_dir, visited_positions))
