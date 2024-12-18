using AStarSearch

const DIRS = [(0, -1), (0, 1), (-1, 0), (1, 0)]

function mazeneighbours(maze, p)
    res = []
    for d in DIRS 
        n = p .+ d
        if (1 ≤ n[1] ≤ 71) && (1 ≤ n[2] ≤ 71) && ~(n in maze)
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


function parse_input(line)
    line = split(line, ",")
    x = parse(Int, line[1])+1
    y = parse(Int, line[2])+1
    return (x, y)
end


function main()
    input = "input.txt"
    input = readlines(input)
    obstacles = parse_input.(input)
    # println(obstacles)
    start = (1, 1)
    goal = (71, 71)

    idx = 1024
    while true
        obs = obstacles[1:idx]
        path = solvemaze(obs, start, goal)
        println("Path length: ", path.cost)
        if path.cost == 0
            println("Position: ", obstacles[idx].-1)
            break
        end
        idx += 1

    end

end

main()