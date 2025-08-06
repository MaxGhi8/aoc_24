# using Pkg
# Pkg.add("Graphs")
using Graphs

function parse_maze(maze)
    grid = [collect(line) for line in split(maze, "\n")]
    nodes = Dict()
    count = 1

    # Assign unique indices to each traversable tile
    for y in 1:length(grid)
        for x in 1:length(grid[y])
            if grid[y][x] != '#'
                nodes[(x, y)] = count
                count += 1
            end
        end
    end
    return grid, nodes
end

function create_graph(grid, nodes)
    # Number of nodes
    n = length(nodes)
    g = SimpleWeightedGraph(n)

    directions = [
        (1, 0),  # East
        (0, 1),  # South
        (-1, 0), # West
        (0, -1)  # North
    ]

    # For each node, add edges to valid neighbors
    for ((x, y), i) in nodes
        for (dx, dy) in directions
            nx, ny = x + dx, y + dy
            if (nx, ny) in nodes
                j = nodes[(nx, ny)]
                add_edge!(g, i, j, 1.0) # Cost for moving forward
            end
        end
    end

    return g
end

# Example Input Maze
maze = """
###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############
"""

# Parse maze and create graph
grid, nodes = parse_maze(maze)
graph = create_graph(grid, nodes)

# Display graph properties
println("Number of nodes: ", nv(graph))
println("Number of edges: ", ne(graph))
println("Nodes: ", nodes)

# Print adjacency matrix
println("\nAdjacency Matrix:")
println(adjacency_matrix(graph))
