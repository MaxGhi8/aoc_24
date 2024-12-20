using AStarSearch

const DIRS = [(0, -1), (0, 1), (-1, 0), (1, 0)]

function mazeneighbours(maze, p, rows, cols)
    res = []
    for d in DIRS 
        n = p .+ d
        if (1 ≤ n[1] ≤ rows) && (1 ≤ n[2] ≤ cols) && n in maze
            push!(res, n)
        end
    end
    return res
end

function solvemaze(maze, start, goal, rows, cols)
    currentmazeneighbours(state) = mazeneighbours(maze, state, rows, cols)
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

function cheat(path, cheat_num)
    count = 0

    for (idx, pos) in enumerate(path)
        for dir in DIRS
            if !(pos .+ dir in path) && (pos .+ dir .+ dir in path[idx+cheat_num+2:end])
                count += 1
            end
        end
    end

    return count

end

function main()
    input = "input.txt"
    input = readlines(input)
    rows = length(input)
    cols = length(input[1])
    input = find_positions(input, ['S', 'E', '.'])
    # println(rows)
    # println(cols)
    # println(input)

    start = input['S'][1]
    goal = input['E'][1]
    maze = Set(input['.'])
    push!(maze, start)
    push!(maze, goal)
    # println("Start: ", start)
    # println("Goal: ", goal)
    # println(mazeneighbours(maze, start, rows, cols))

    path = solvemaze(maze, start, goal, rows, cols)
    # println("Path: ", path.path)
    println("Path length: ", path.cost)

    println(cheat(path.path, 100))

end

main()