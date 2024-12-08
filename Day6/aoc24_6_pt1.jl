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

(start_pos, start_dir) = find_guard(grid)

# Directions and their corresponding movements
directions = Dict('^' => (-1, 0), 'v' => (1, 0), '<' => (0, -1), '>' => (0, 1))
turn_right = Dict('^' => '>', '>' => 'v', 'v' => '<', '<' => '^')

# Simulate the guard's movement
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

# Run the simulation
visited_positions = simulate_guard(grid, start_pos, start_dir)

# Output the number of distinct positions visited
println("Number of distinct positions visited: ", length(visited_positions))
