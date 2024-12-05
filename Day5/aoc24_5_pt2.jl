function parse_input(input::String)
    # Split sections
    input = readlines(input)
    index = findfirst(x -> x == "", input)
    parts = input[1:index-1]
    rules = input[index+1:end]
    
    # Parse rules into tuples of integers
    ordering_rules = [parse.(Int, split(part, '|')) for part in parts]
    
    # Parse updates into arrays of integers
    update_lists = [parse.(Int, split(rule, ',')) for rule in rules]
    
    return ordering_rules, update_lists
end

function is_valid_update(update, rules)
    # Create a dictionary to store the index of each page in the update
    page_index = Dict(page => i for (i, page) in enumerate(update))
    
    for (x, y) in rules
        # Check if both pages x and y are in the dictionary
        if haskey(page_index, x) && haskey(page_index, y)
            # If x's index is greater than or equal to y's index, update is invalid
            if page_index[x] >= page_index[y]
                return false
            end
        end
    end
    return true
end

function middle_page(update)
    n = length(update)
    return update[div(n, 2) + 1]  # Get the middle element
end

function reorder(update, rules)
    # Create a dictionary to store the index of each page in the update
    page_index = Dict(page => i for (i, page) in enumerate(update))

    for (x, y) in rules
        # Check if both pages x and y are in the dictionary
        if haskey(page_index, x) && haskey(page_index, y)
            # If x's index is greater than or equal to y's index, update is invalid
            if page_index[x] >= page_index[y]
                index_x = findfirst(l -> l == x, update)
                index_y = findfirst(l -> l ==y, update)
                update[index_x] = y
                update[index_y] = x
                return reorder(update, rules)
            end
        end
    end
    return update
end

function solve_puzzle(input::String)
    rules, updates = parse_input(input)
    
    # Filter valid updates
    invalid_updates = [update for update in updates if !is_valid_update(update, rules)]

    valid_updates = [reorder(update, rules) for update in invalid_updates]
    
    # Calculate the middle pages of valid updates
    middle_pages = [middle_page(update) for update in valid_updates]
    
    # Return the sum of the middle pages
    return sum(middle_pages)
end

println(solve_puzzle("input.txt"))