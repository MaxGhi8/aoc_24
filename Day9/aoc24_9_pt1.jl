input = "input.txt"
input = readlines(input)[1]

# Parse the input string to expand it into block-by-block representation
function parse_disk_map(disk_map::String)
    blocks = []
    toggle = true  # True for file, False for free space
    file_id = 0
    for digit in disk_map
        count = parse(Int, string(digit))
        if toggle
            append!(blocks, fill(file_id, count))
            file_id += 1
        else
            append!(blocks, fill('.', count))
        end
        toggle = !toggle
    end
    return blocks
end

# Compact the disk by moving file blocks to the leftmost free space
function compact_disk(blocks::Vector{Any})
    while '.' in blocks
        free_idx = findfirst(==('.'), blocks)
        last_file_idx = findlast(!=('.'), blocks)
        if free_idx < last_file_idx
            # Swap the last file block with the leftmost free space
            blocks[free_idx], blocks[last_file_idx] = blocks[last_file_idx], blocks[free_idx]
        else
            break
        end
    end
    return blocks
end

# Compute the checksum
function compute_checksum(blocks::Vector{Any})
    checksum = 0
    for (i, block) in enumerate(blocks)
        if block != '.'
            checksum += (i-1) * block
        else
            break
        end
    end
    return checksum
end

# Main function
function main(disk_map::String)
    blocks = parse_disk_map(disk_map)
    # println("Blocks: ", blocks)
    compacted_blocks = compact_disk(blocks)
    # println("Compacted blocks: ", compacted_blocks)
    return compute_checksum(compacted_blocks)
end

# Input disk map
println("Checksum: ", main(input))
