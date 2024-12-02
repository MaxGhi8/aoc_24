lines = readlines("input.txt")
lines = split.(lines,"   ")
list1 = sort(parse.(Int, getindex.(lines, 1)))
list2 = sort(parse.(Int, getindex.(lines, 2)))

pt1answer = sum(abs.(list1 .- list2))
println(pt1answer)
pt2answer = sum(filter(x -> x in list1, list2))
println(pt2answer)