
# Define a function to simulate the 3-bit computer
function simulate_program(program::Vector{Int}, regA::Int, regB::Int, regC::Int)
    # Initialize registers and instruction pointer
    A, B, C = regA, regB, regC
    instruction_pointer = 1  # Julia uses 1-based indexing
    output = []  # Output storage
    
    # Helper function to interpret combo operands
    combo_value(operand) = if operand in 0:3
        operand  # Literal values 0-3
    elseif operand == 4
        A  # Register A
    elseif operand == 5
        B  # Register B
    elseif operand == 6
        C  # Register C
    else
        error("Invalid combo operand: $operand")
    end

    # Program execution loop
    while instruction_pointer <= length(program)
        opcode = program[instruction_pointer]       # Fetch the instruction opcode
        operand = program[instruction_pointer + 1]  # Fetch the operand
        
        # Process instruction based on its opcode
        if opcode == 0  # adv: Divide A by 2^operand (combo)
            denom = 2^combo_value(operand)
            A = div(A, denom)  # Integer division
        elseif opcode == 1  # bxl: XOR B with literal operand
            B = B ⊻ operand
        elseif opcode == 2  # bst: B = operand % 8 (combo)
            B = combo_value(operand) % 8
        elseif opcode == 3  # jnz: Jump to operand (literal) if A != 0
            if A != 0 && instruction_pointer != operand + 1
                instruction_pointer = operand + 1  # Jump to operand (literal value)
                continue  # Skip the usual pointer increment
            end
        elseif opcode == 4  # bxc: XOR B with C (operand ignored)
            B = B ⊻ C
        elseif opcode == 5  # out: Output operand % 8 (combo)
            push!(output, combo_value(operand) % 8)
        elseif opcode == 6  # bdv: Divide A by 2^operand (combo) and store in B
            denom = 2^combo_value(operand)
            B = div(A, denom)  # Integer division
        elseif opcode == 7  # cdv: Divide A by 2^operand (combo) and store in C
            denom = 2^combo_value(operand)
            C = div(A, denom)  # Integer division
        else
            error("Invalid opcode: $opcode")
        end

        # Increment the instruction pointer by 2
        instruction_pointer += 2
    end
    
    # Return output as a comma-separated string
    return join(output, ",")
end

# Example program and initial registers
# program = [0,1,5,4,3,0]  # The example program
# regA = 729  # Initial value of register A
program = [0,3,5,4,3,0]  # The example program
regA = 117440# Initial value of register A
regB = 0    # Initial value of register B
regC = 0    # Initial value of register C

# Run the program
output = simulate_program(program, regA, regB, regC)

# Print the output
println("Program Output: ", output)
