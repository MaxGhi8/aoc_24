using Pkg
# Pkg.add("AStarSearch")
using AStarSearch

const UP = CartesianIndex(-1, 0)
const DOWN = CartesianIndex(1, 0)
const LEFT = CartesianIndex(0, -1)
const RIGHT = CartesianIndex(0, 1)
const DIRECTIONS = [UP, DOWN, LEFT, RIGHT]

# Parse the maze and find start and end positions
function parse_maze(maze)
    start = nothing
    end_ = nothing
    grid = []
    for (y, line) in enumerate(split(maze, "\n"))
        push!(grid, collect(line))
        for (x, cell) in enumerate(line)
            if cell == 'S'
                start = (x, y)
            elseif cell == 'E'
                end_ = (x, y)
            end
        end
    end
    return grid, start, end_
end


function mazeneighbours(maze, p)
    res = CartesianIndex[]
    for d in DIRECTIONS
        n = CartesianIndex(p) + d
        if (1 ≤ n[1] ≤ length(maze)) && (1 ≤ n[2] ≤ length(maze[1])) && (maze[n[1]][n[2]] != '#')
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


# Main function to solve the maze
function main()
    input = read("input.txt", String)
    input = replace(input, "\r\n" => "\n")
    grid, start, goal = parse_maze(input)
    # println(grid)
    # println(start)
    # println(goal)
    
    path = solvemaze(grid, start, goal)
    println("Path length: ", path.cost)
end


# Solve
main()