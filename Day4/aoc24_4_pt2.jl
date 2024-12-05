lines = readlines("input.txt")

function count_x_mas(grid)
    rows = length(grid)
    cols = length(grid[1])
    total_count = 0
    
    # Loop over each cell and check for "X-MAS"
    for r in 1:rows
        for c in 1:cols
            flag = 0
            if grid[r][c] == 'A'
                if r + 1 <= rows && r - 1 >= 1 && c + 1 <= cols && c - 1 >= 1
                    if (grid[r+1][c+1] == 'S' && grid[r-1][c-1] == 'M') || (grid[r+1][c+1] == 'M' && grid[r-1][c-1] == 'S')
                        flag += 1
                    end
                    if (grid[r+1][c-1] == 'S' && grid[r-1][c+1] == 'M') || (grid[r+1][c-1] == 'M' && grid[r-1][c+1] == 'S')
                        flag += 1
                    end
                    if flag == 2
                        total_count += 1
                    end
                end
            end
        end
    end
    
    return total_count
end

println(count_x_mas(lines))