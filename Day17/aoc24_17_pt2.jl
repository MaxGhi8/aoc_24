function part_two()
    answer = 0

    regA = 8^15 # Initial value for register A
    regB = 0  # Initial value for register B
    regC = 0  # Initial value for register C
    program = [2,4,1,3,7,5,0,3,4,1,1,5,5,5,3,0]
    program_string = "2,4,1,3,7,5,0,3,4,1,1,5,5,5,3,0"

    # Define the test function
    test(a) = (((a % 8) ⊻ 3) ⊻ 5) ⊻ (a ÷ 2^( ((a % 8) ⊻ 3) )) % 8

    # Initialize list of possible answers
    answers = [0]

    # Iterate over the program in reverse
    for p in reverse(program)
        new_answers = Int[]  # Initialize empty array for new answers
        for curr in answers
            for a in 0:7  # Range of 8 values (0 to 7)
                to_test = (curr << 3) + a  # Bitwise left shift (equivalent to curr * 8 + a)
                out = test(to_test)
                if out == p
                    push!(new_answers, to_test)
                end
            end
        end
        answers = new_answers
    end

    # Find the minimum answer
    answer = minimum(answers)

    println("Part 2: $answer")
end

part_two()