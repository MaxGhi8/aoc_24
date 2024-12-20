using AStarSearch

const DIRS = [(0, -1), (0, 1), (-1, 0), (1, 0)]

function mazeneighbours(maze, p)
    res = []
    for d in DIRS 
        n = p .+ d
        if n in maze
            push!(res, n)
        end
    end
    return res
end

function solvemaze(maze, start, goal)
    currentmazeneighbours(state) = mazeneighbours(maze, state)
    # Here you can use any of the exported search functions, they all share the same interface, but they won't use the heuristic and the cost
    return astar(currentmazeneighbours, start, goal)
end


# Function to find positions of specific characters
function find_positions(maze, chars)
    positions = Dict(char => [] for char in chars)
    for i in 1:length(maze)
        for j in 1:length(maze[i])
            char = maze[i][j]
            if char in chars
                push!(positions[char], (i, j))
            end
        end
    end
    return positions
end

function distance(p1, p2)
    return abs(p1[1] - p2[1]) + abs(p1[2] - p2[2])
end
# println(distance((1, 2), (2, 3)))

function find_cheat(path, cheat_num, cheat_max_len, obstacles)
    count = 0
    for (idx, pos) in enumerate(path)
        # println(idx)
        for (new_idx, new_pos) in enumerate(path[idx+cheat_num:end])

            if distance(pos, new_pos) <= cheat_max_len && new_idx >= distance(pos, new_pos)
                count += 1
            end
        end
    end
    return count
end

function main()
    input = "input.txt"
    input = readlines(input)
    input = find_positions(input, ['S', 'E', '.', '#'])
    # println(rows)
    # println(cols)
    # println(input)

    start = input['S'][1]
    goal = input['E'][1]
    maze = Set(input['.'])
    obstacles = Set(input['#'])
    push!(maze, start)
    push!(maze, goal)
    # println("Start: ", start)
    # println("Goal: ", goal)
    # println(mazeneighbours(maze, start, rows, cols))

    Path = solvemaze(maze, start, goal)
    # println("Path: ", path.path)
    println("Path length: ", Path.cost)

    println(find_cheat(Path.path, 100, 20, obstacles))


end

main()