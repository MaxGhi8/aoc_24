input = "input.txt"
input = readlines(input)[1]

# Parse the input string to expand it into block-by-block representation
function parse_disk_map(disk_map::String)
    blocks = []
    toggle = true  # True for file, False for free space
    number = 0
    for digit in disk_map
        count = parse(Int, string(digit))
        if toggle
            append!(blocks, [[count, number]])
            number += 1
        else
            append!(blocks, [[count, '.']])
        end
        toggle = !toggle
    end
    return blocks 
end

# Compact the disk by moving file blocks to the leftmost free space
function compact_disk(blocks)
    reversed_blocks = reverse(filter(x -> x[2] != '.', blocks))
    for block in reversed_blocks
        num_block = block[1] # total numbers to move
        idx_block = findfirst(x -> x==block, blocks) # original idx

        for (idx, bl) in enumerate(blocks) 
            # stop condition
            if bl == block
                break
            # switch condition
            elseif bl[2] == '.' && bl[1] >= num_block
                    blocks = cat([b for b in blocks[1:idx-1]], # unchanged first part of the list
                        [[0, '.']], # empty separator
                        [block], # moved block
                        [ [blocks[idx][1]- num_block, '.']],
                        [b for b in blocks[idx+1:idx_block-2]], # unchanged middle part of the list
                        [ [num_block + blocks[idx_block-1][1] + blocks[idx_block+1][1], '.'] ], # merged list with '.'
                        [b for b in blocks[idx_block+2:end]], # unchanged last part of the list
                        dims = 1)
                break
            end
        end
    end
    return blocks
end

function compute_checksum(compacted_blocks)
    i = 0
    checksum = 0
    for block in compacted_blocks
        counter = block[1]
        num = block[2]
        # update checksum
        if num != '.'
            checksum += (sum([j for j in i:i+counter-1])) * num
        end
        # update i
        i += counter
    end
    return checksum
end


# Main function
function main(disk_map::String)
    blocks = parse_disk_map(disk_map)
    if blocks[end][2] != '.'
        append!(blocks, [[0, '.']])
    end
    # println("Blocks: ", blocks)
    compacted_blocks = compact_disk(blocks)
    # println("Compacted blocks: ", compacted_blocks)
    return compute_checksum(compacted_blocks)
end

# Input disk map
println("Checksum: ", main(input))

# 6304576012713