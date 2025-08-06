import networkx as nx


def parse_maze(maze_input):
    """Parse the maze into a grid of tiles."""
    with open(maze_input, "r") as file:
        maze_string = file.read()

    grid = []
    for row in maze_string.strip().split("\n"):
        grid.append(list(row))
    return grid


def find_positions(grid, char):
    """Find all positions of a character in the grid."""
    positions = []
    for y, row in enumerate(grid):
        for x, cell in enumerate(row):
            if cell == char:
                positions.append((x, y))
    return positions


def add_edges_for_node(graph, grid, x, y, facing, weight=1):
    """Add edges for a given node considering its facing direction."""
    directions = {"N": (0, -1), "E": (1, 0), "S": (0, 1), "W": (-1, 0)}
    clockwise = {"N": "E", "E": "S", "S": "W", "W": "N"}
    counterclockwise = {v: k for k, v in clockwise.items()}

    # Add edge for moving forward
    dx, dy = directions[facing]
    nx, ny = x + dx, y + dy
    if 0 <= ny < len(grid) and 0 <= nx < len(grid[0]) and grid[ny][nx] != "#":
        graph.add_edge((x, y, facing), (nx, ny, facing), weight=1)

    # Add edges for rotations
    graph.add_edge((x, y, facing), (x, y, clockwise[facing]), weight=1000)
    graph.add_edge((x, y, facing), (x, y, counterclockwise[facing]), weight=1000)


def build_graph(grid):
    """Build the graph for the maze."""
    graph = nx.DiGraph()
    directions = ["N", "E", "S", "W"]

    for y, row in enumerate(grid):
        for x, cell in enumerate(row):
            if cell != "#":
                for facing in directions:
                    add_edges_for_node(graph, grid, x, y, facing)

    return graph


def reindeer_maze_solver(maze_input):
    """Solve the Reindeer Maze problem."""
    grid = parse_maze(maze_input)
    start_pos = find_positions(grid, "S")[0]
    end_pos = find_positions(grid, "E")[0]

    graph = build_graph(grid)

    # Define start and end states with directions
    start_state = (start_pos[0], start_pos[1], "E")  # Start facing East
    end_states = [(end_pos[0], end_pos[1], d) for d in ["N", "E", "S", "W"]]

    # Find the shortest path
    shortest_path = None
    shortest_cost = float("inf")

    for end_state in end_states:
        try:
            path_length = nx.shortest_path_length(
                graph, start_state, end_state, weight="weight"
            )
            if path_length < shortest_cost:
                shortest_cost = path_length
                shortest_path = nx.shortest_path(
                    graph, start_state, end_state, weight="weight"
                )
        except nx.NetworkXNoPath:
            continue

    return shortest_path, shortest_cost


# Example maze input
maze_input = "input.txt"

# Solve the maze
path, cost = reindeer_maze_solver(maze_input)
print("Shortest Path:", path)
print("Cost:", cost)
