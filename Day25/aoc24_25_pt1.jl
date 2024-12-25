function read_schematic(file_path)
    # Read the file into an array of lines
    lines = readlines(file_path)

    schematics = []
    current_schematic = []

    # Parse the file into schematics
    for line in lines
        if isempty(strip(line)) && !isempty(current_schematic) # Separator between schematics
            push!(schematics, current_schematic)
            current_schematic = []
        else
            push!(current_schematic, line)
        end
    end
    # Add the last schematic if any
    if !isempty(current_schematic)
        push!(schematics, current_schematic)
    end

    heights_lock = []
    heights_keys = []

    for schematic in schematics
        top_row = schematic[1]
        bottom_row = schematic[end]

        if all(c -> c == '#', top_row) && all(c -> c == '.', bottom_row) # Lock
            push!(heights_lock, parse_lock(schematic[2:end]))
        elseif all(c -> c == '.', top_row) && all(c -> c == '#', bottom_row) # Key
            push!(heights_keys, parse_lock(schematic[1:end-1]))
        else
            error("Invalid schematic format")
        end
    end

    return heights_lock, heights_keys
end

function parse_lock(schematic)
    num_cols = length(schematic[1])
    heights = zeros(1, num_cols)

    for row in schematic
        for col in 1:num_cols
            if row[col] == '#'
                heights[col] += 1
            end
        end
    end

    return heights
end

function overlap(heights_lock, heights_keys)
    num_rows = 5
    num_cols = length(heights_lock[1])

    counter = 0
    for lock in heights_lock
        for key in heights_keys
            flag = 0
            for col in 1:num_cols
                if lock[col] + key[col] <= num_rows
                    flag += 1
                end
            end
            if flag == num_cols
                counter += 1
            end
        end
    end

    return counter 
end


function main()
    input = "input.txt"
    heights_lock, heights_keys = read_schematic(input)
    # println("Locks: ", heights_lock)
    # println("Keys: ", heights_keys)

    valid_pair = overlap(heights_lock, heights_keys)
    println("Valid pairs: ", valid_pair)
    
end

main()