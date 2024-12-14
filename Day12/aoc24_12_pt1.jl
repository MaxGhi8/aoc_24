function calculate_area_and_perimeter(garden_map::Matrix{Char})
    nrows, ncols = size(garden_map)
    visited = falses(nrows, ncols)

    # Directions for moving: up, down, left, right
    directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]

    # Function to perform DFS for a region
    function dfs(row, col, plant_type)
        stack = [(row, col)]
        area = 0
        perimeter = 0

        while !isempty(stack)
            r, c = pop!(stack)
            
            if visited[r, c]
                continue
            end

            visited[r, c] = true
            area += 1
            local_perimeter = 4

            for (dr, dc) in directions
                nr, nc = r + dr, c + dc

                if nr >= 1 && nr <= nrows && nc >= 1 && nc <= ncols
                    if garden_map[nr, nc] == plant_type
                        if !visited[nr, nc]
                            push!(stack, (nr, nc))
                        end
                        local_perimeter -= 1
                    end
                end
            end

            perimeter += local_perimeter
        end

        return area, perimeter
    end

    # Dictionary to store results
    results = Dict{Char, Vector{Tuple{Int, Int}}}()

    # Traverse the garden map
    for r in 1:nrows
        for c in 1:ncols
            if !visited[r, c]
                plant_type = garden_map[r, c]
                area, perimeter = dfs(r, c, plant_type)
                if haskey(results, plant_type)
                    push!(results[plant_type], (area, perimeter))
                else
                    results[plant_type] = [(area, perimeter)]
                end
            end
        end
    end

    return results
end

function parse_garden_map(input::String)::Matrix{Char}
    input = read(input, String)
    input = replace(input, "\r\n" => "\n")
    lines = split(input, '\n')
    nrows = length(lines)
    ncols = length(lines[1])
    garden_map = Matrix{Char}(undef, nrows, ncols)
    for (i, line) in enumerate(lines)
        garden_map[i, :] = collect(line)
    end
    return garden_map
end
garden_map = parse_garden_map("input.txt")

results = calculate_area_and_perimeter(garden_map)

# Display the results
# for (plant_type, regions) in results
#     println("Plant type: $plant_type")
#     for (area, perimeter) in regions
#         println("  Area: $area, Perimeter: $perimeter")
#     end
# end

function get_result(results)
    tot = 0
    for (plant_type, regions) in results
        for (area, perimeter) in regions
            tot += area * perimeter
        end
    end
    return tot
end

println(get_result(results))