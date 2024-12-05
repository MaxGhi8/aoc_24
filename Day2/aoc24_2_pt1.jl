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