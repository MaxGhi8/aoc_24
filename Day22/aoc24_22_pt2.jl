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
    secret_numbers = Int[]
    current_secret = initial_secret

    for _ in 1:count
        current_secret = next_secret_number(current_secret)
        push!(secret_numbers, current_secret)
    end

    return secret_numbers
end


function extract_prices(secret_numbers::Vector{Int})
    return [n % 10 for n in secret_numbers]
end

function calculate_changes(prices::Vector{Int})
    return [prices[i] - prices[i-1] for i in 2:length(prices)]
end

function find_best_sequence(initial_secrets::Vector{Int}, num_changes::Int, sequence_length::Int)
    total_bananas = Dict{Vector{Int}, Int}()

    for initial_secret in initial_secrets
        secret_numbers = generate_secret_numbers(initial_secret, num_changes)
        prices = extract_prices(secret_numbers)
        changes = calculate_changes(prices)

        visited = Set{Vector{Int}}()

        for i in 1:(length(changes) - sequence_length + 1)
            seq = changes[i:i+sequence_length-1]

            if seq in visited
                continue
            end
            push!(visited, seq)
            
            total_bananas[seq] = get(total_bananas, seq, 0) + prices[i + sequence_length]
        end
    end

    best_sequence, max_bananas = argmax(total_bananas), maximum(values(total_bananas))
    return best_sequence, max_bananas
end

function main()
    input = readlines("input.txt")
    input = parse.(Int, input)
    # println(input)

    number_count = 2000
    sequence_length = 4
    best_sequence, max_bananas = find_best_sequence(input, number_count, sequence_length)

    # println(secret_numbers)

    println(best_sequence, max_bananas)

end

main()