# using Pkg
# Pkg.add("Combinatorics")
using Combinatorics

# Input
input = "input.txt"
connections = readlines(input)

# build the graph
graph = Dict{String, Set{String}}()
for connection in connections
    a, b = split(connection, "-")
    if !haskey(graph, a)
        graph[a] = Set{String}()
    end
    if !haskey(graph, b)
        graph[b] = Set{String}()
    end
    push!(graph[a], b)
    push!(graph[b], a)
end

# build the triangles
triangles = Set{Tuple{String, String, String}}()
for (node, neighbors) in graph
    for (n1, n2) in combinations(collect(neighbors), 2)
        if n2 in graph[n1]
            triangle = Tuple(sort([node, n1, n2]))
            push!(triangles, triangle)
        end
    end
end

triangles_with_t = filter(triangle -> any(startswith("t"), triangle), triangles)
println("Total triangles: ", length(triangles))
println("Triangles with 't': ", length(triangles_with_t))
