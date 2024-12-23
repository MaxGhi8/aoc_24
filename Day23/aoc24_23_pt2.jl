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

# Step 2: Bron-Kerbosch algorithm to find all cliques 
function bron_kerbosch(graph, r, p, x, cliques)
    if isempty(p) && isempty(x)
        push!(cliques, r)  # Found a clique
    else
        for v in copy(p)
            neighbors = graph[v]
            bron_kerbosch(graph, union(r, [v]), intersect(p, neighbors), intersect(x, neighbors), cliques)
            p = setdiff(p, [v])
            x = union(x, [v])
        end
    end
end

# Step 3: Find all cliques
all_cliques = Set{Set{String}}()
bron_kerbosch(graph, Set{String}(), Set(keys(graph)), Set{String}(), all_cliques)

# Step 4: Identify the largest clique
largest_clique = reduce((a, b) -> length(a) > length(b) ? a : b, all_cliques)

# Step 5: Format the password
password = join(sort(collect(largest_clique)), ",")

# Output the password
println("LAN party password: ", password)
