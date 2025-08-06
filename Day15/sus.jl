
function part1()
    inp = read("input.txt", String)

    grid, moves = eachsplit(inp, "\n\n")

    w = 0
    h = 0
    mat = Char[]

    for l in eachsplit(grid, '\n')
        w = length(l)
        h += 1
        append!(mat, l)
    end

    mat = reshape(mat, w, h)

    pos = (0, 0)

    for y in 1:h, x in 1:w
        if mat[x, y] == '@'
            pos = (x, y)
            mat[x, y] = '.'
            break
        end
    end

    dirs = Dict([
        '^' => (0, -1),
        'v' => (0, 1),
        '<' => (-1, 0),
        '>' => (1, 0),
    ])

    for d in moves
        if d in "^v<>"
            dir = dirs[d]

            freespace = pos .+ dir
            while mat[freespace...] == 'O'
                freespace = freespace .+ dir
            end

            npos = pos .+ dir

            if mat[freespace...] == '.'
                if npos != freespace
                    mat[freespace...] = 'O'
                    mat[npos...] = '.'
                end

                pos = npos
            end
        end
    end

    s = 0

    for y in 1:h, x in 1:w
        if mat[x, y] == 'O'
            s += (x - 1) + 100(y - 1)
        end
    end

    s
end

function showstate(mat, pos)
    w, h = size(mat)

    for y in 1:h
        for x in 1:w
            if (x, y) == pos
                print('@')
            else
                print(mat[x, y])
            end
        end
        println()
    end
end

function part2()
    inp = read("input.txt", String)

    grid, moves = eachsplit(inp, "\n\n")

    w = 0
    h = 0
    mat = Char[]

    for l in eachsplit(grid, '\n')
        w = 2 * length(l)
        h += 1

        for x in l
            append!(mat, if x == '#'
                "##"
            elseif x == 'O'
                "[]"
            elseif x == '.'
                ".."
            elseif x == '@'
                "@."
            end)
        end
    end

    mat = reshape(mat, w, h)

    pos = (0, 0)

    for y in 1:h, x in 1:w
        if mat[x, y] == '@'
            pos = (x, y)
            mat[x, y] = '.'
            break
        end
    end

    dirs = Dict([
        '^' => (0, -1),
        'v' => (0, 1),
        '<' => (-1, 0),
        '>' => (1, 0),
    ])

    for (i, d) in enumerate(moves)
        if d in "<>"
            dir = dirs[d]

            freespace = pos .+ dir
            nmov = 0
            while mat[freespace...] in "[]"
                freespace = freespace .+ dir
                nmov += 1
            end

            npos = pos .+ dir

            if mat[freespace...] == '.'
                curpos = freespace
                prevpos = freespace .- dir
                for _ in 1:nmov
                    mat[curpos...] = mat[prevpos...]
                    curpos = prevpos
                    prevpos = prevpos .- dir
                end

                pos = npos
                mat[pos...] = '.'
            end
        elseif d in "^v"
            dir = dirs[d]

            boxes_to_move = NTuple{2,Int}[]

            npos = pos .+ dir
            can_move = if mat[npos...] == '['
                push_box(mat, npos, dir[2], boxes_to_move)
            elseif mat[npos...] == ']'
                push_box(mat, npos .+ (-1, 0), dir[2], boxes_to_move)
            elseif mat[npos...] == '.'
                true
            elseif mat[npos...] == '#'
                false
            end

            sort!(boxes_to_move, by=((x, y),) -> (y .* -dir[2], x))

            if can_move
                if i == 197
                    @show boxes_to_move
                    @show pos
                    showstate(mat, pos)
                end

                for box in boxes_to_move
                    mat[box...] = '.'
                    mat[(box .+ (1, 0))...] = '.'
                    mat[(box .+ dir)...] = '['
                    mat[(box .+ dir .+ (1, 0))...] = ']'
                end

                pos = npos
                if i == 197
                    showstate(mat, pos)
                end
            end
        end
    end

    s = 0

    for y in 1:h, x in 1:w
        if mat[x, y] == '['
            s += (x - 1) + 100(y - 1)
        end
    end

    s
end

function push_box(mat, pos, ydir, boxes_to_move)
    push!(boxes_to_move, pos)

    lpos = pos .+ (0, ydir)
    rpos = pos .+ (1, ydir)

    if mat[lpos...] == '#' || mat[rpos...] == '#'
        return false
    end

    if mat[lpos...] == '['
        push_box(mat, lpos, ydir, boxes_to_move) || return false
    else
        if mat[lpos...] == ']'
            push_box(mat, lpos .+ (-1, 0), ydir, boxes_to_move) || return false
        end

        if mat[rpos...] == '[' && rpos ∉ boxes_to_move
            push_box(mat, rpos, ydir, boxes_to_move) || return false
        end
    end

    true
end

println(part1())
println(part2())