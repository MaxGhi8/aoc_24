input = "input.txt"

function parse_input(grid)
    positions = Dict{Char, Vector{Tuple{Int, Int}}}()

    # Loop over rows and columns
    for (i, row) in enumerate(grid)
        for (j, char) in enumerate(row)
            if char != '.'  # Ignore dots
                if !haskey(positions, char)
                    positions[char] = []
                end
                push!(positions[char], (i, j))
            end
        end
    end
    return positions
end

function create_antinode(positions, grid)
    rows = length(grid)
    cols = length(grid[1])
    antinode = Set{Tuple{Int, Int}}()

    for (char, pos) in positions

        for p in pos, q in pos
            if p != q

                dir = (q[1] - p[1], q[2] - p[2])
                magnitude = floor(sqrt(dir[1]^2 + dir[2]^2))
                k_max = floor(min(rows, cols)/magnitude)
                for k = -k_max : k_max
                    xm = q[1] + k * dir[1]
                    ym = q[2] + k * dir[2]
                    if 1 <= xm <= rows && 1 <= ym <= cols
                        push!(antinode, (xm, ym))
                    end
                end

            end
        end
    end
    return antinode

end

grid = readlines(input)
antennas = parse_input(grid)
println(length(create_antinode(antennas, grid)))