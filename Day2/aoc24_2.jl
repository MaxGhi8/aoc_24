function parse_list(Ls)
    return parse.(Int, Ls)
end

function is_non_increasing(lst)
    all( 0 < lst[i + 1] - lst[i] <= 3  for i in 1:length(lst)-1)
end

function is_non_decreasing(lst)
    all( 0 < lst[i] - lst[i+1] <= 3  for i in 1:length(lst)-1)
end

lines = readlines("input.txt")
lines = split.(lines," ")
lines = parse_list.(lines)
non_inc = filter(is_non_increasing, lines)
non_dec = filter(is_non_decreasing, lines)
println(length(non_inc) + length(non_dec))

function filter_part2(lst)
    # Check the list directly first
    if is_non_decreasing(lst) || is_non_increasing(lst)
        return true
    end

    # Check by removing one element at a time
    return any(is_non_decreasing(deleteat!(copy(lst), idx)) || 
               is_non_increasing(deleteat!(copy(lst), idx)) for idx in 1:length(lst))
end

println(length(filter(filter_part2, lines)))