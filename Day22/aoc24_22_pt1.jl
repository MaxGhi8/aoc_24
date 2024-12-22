function next_secret_number(secret_number::Int)
    MODULO = 16777216  # Pruning modulus

    # Step 1: Multiply by 64, mix, and prune
    step1 = (secret_number * 64) ⊻ secret_number
    step1 %= MODULO

    # Step 2: Divide by 32, floor, mix, and prune
    step2 = (div(step1, 32)) ⊻ step1
    step2 %= MODULO

    # Step 3: Multiply by 2048, mix, and prune
    step3 = (step2 * 2048) ⊻ step2
    step3 %= MODULO

    return step3
end

function generate_secret_numbers(initial_secret::Int, count::Int)
    current_secret = initial_secret

    for _ in 1:count
        current_secret = next_secret_number(current_secret)
    end

    return current_secret
end

function main()
    input = readlines("input.txt")
    input = parse.(Int, input)
    # println(input)

    number_count = 2000
    secret_numbers = generate_secret_numbers.(input, number_count)
    # println(secret_numbers)

    println(sum(secret_numbers))

end

main()