lines = readlines("input.txt")

function count_xmas(grid)
    rows = length(grid)
    cols = length(grid[1])
    word = "XMAS"
    word_len = length(word)
    total_count = 0
    
    # Check in all 8 directions
    directions = [
        (0, 1),  # right
        (0, -1), # left
        (1, 0),  # down
        (-1, 0), # up
        (1, 1),  # down-right diagonal
        (-1, -1),# up-left diagonal
        (1, -1), # down-left diagonal
        (-1, 1)  # up-right diagonal
    ]
    
    # Helper to check if a word fits starting at (r, c) in direction (dr, dc)
    function fits(r, c, dr, dc)
        for k in 0:(word_len - 1)
            rr, cc = r + k * dr, c + k * dc
            if rr < 1 || rr > rows || cc < 1 || cc > cols || grid[rr][cc] != word[k + 1]
                return false
            end
        end
        return true
    end
    
    # Loop over each cell and check for "XMAS"
    for r in 1:rows
        for c in 1:cols
            for (dr, dc) in directions
                if fits(r, c, dr, dc)
                    total_count += 1
                end
            end
        end
    end
    
    return total_count
end

println(count_xmas(lines))