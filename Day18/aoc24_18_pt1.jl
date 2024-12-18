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
    input = readlines(input)[1:1024]
    input = parse_input.(input)
    # println(input)

    start = (1, 1)
    goal = (71, 71)
    path = solvemaze(input, start, goal)
    println("Path length: ", path.cost)

end

main()