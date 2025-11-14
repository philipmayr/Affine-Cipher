# Affine Cipher
    
require "readline"

def find_greatest_common_divisor(a, b)
    return (b == 0) ? a : find_greatest_common_divisor(b, a % b)
end

def find_modular_multiplicative_inverse(base, modulus)
    if find_greatest_common_divisor(base, modulus) != 1
        return false
    end
    
    inverse = 0
    residue = 0

    while residue != 1
        residue = (base * inverse) % modulus
        inverse += 1
    end
    
    return inverse - 1
end

loop do
    puts "Enter message to be enciphered below:"
    message = Readline.readline("➤ ", true).chars
    
    puts
    
    encoding_chart = Hash.new
    index = 1
    
    for char in message do
        if encoding_chart[char] == nil
            if index < 10
                encoding_chart[char] = "0" + index.to_s
            else
                encoding_chart[char] = index.to_s
            end
            index += 1
        end
    end
    
    encoded_message = ""
    
    for char in message do
        encoded_message += encoding_chart[char]
    end
    
    remainder = encoded_message.length % 5
    difference = 5 - remainder
    
    while difference > 0
        encoded_message += '0'
        difference -= 1
    end
    
    puts "Encoded message:"
    
    index = 0
    
    for char in encoded_message.chars do
        print char
        index += 1
        if index == 5
            print ' '
            index = 0
        end
    end
    
    puts
    
    puts
    puts "Enter space separated multiplier and increment integers (key pair alpha and beta values) below:"
    key = Readline.readline("➤ ", true)
    
    alpha, beta = key.split
    
    modulus = encoding_chart.length + 1
    
    loop do
        if not find_greatest_common_divisor(alpha.to_i, modulus.to_i) == 1
            puts
            puts "Error: Alpha value (" + alpha.to_s + ") must be relatively prime to modulus value (" + modulus.to_s + ")."
            puts
            puts "Enter space separated multiplier and increment integers (key pair alpha and beta values) below:"
            key = Readline.readline("➤ ", true)
            
            alpha, beta = key.split
            
            modulus = encoding_chart.length + 1
        else
            break
        end
    end
    
    enciphered_message = ""
    
    # y ≡ a ⋅ x + b mod m
    encoded_message.scan(/../) do |pair|
        enciphered_character = ((alpha.to_i * pair.to_i) + beta.to_i) % modulus
        if enciphered_character < 10
            enciphered_character = "0" + enciphered_character.to_s
        else
            enciphered_character = enciphered_character.to_s
        end
        enciphered_message += enciphered_character
    end
    
    while enciphered_message.length % 5 != 0
        enciphered_message += "0"
    end
    
    puts
    puts "Enciphered message:"
    index = 0
    
    for char in enciphered_message.chars do
        print char
        index += 1
        if index == 5
            print ' '
            index = 0
        end
    end
    
    deciphered_message = ""
    
    modular_multiplicative_inverse_of_alpha = find_modular_multiplicative_inverse(alpha.to_i, modulus.to_i)
    
    # x ≡ a⁻¹ ⋅ (y - b) mod m
    enciphered_message.scan(/../) do |pair|
        deciphered_character = modular_multiplicative_inverse_of_alpha * (pair.to_i - beta.to_i) % modulus
        if deciphered_character < 10
            deciphered_character = "0" + deciphered_character.to_s
        else
            deciphered_character = deciphered_character.to_s
        end
        deciphered_message += deciphered_character
    end
    
    while deciphered_message.length % 5 != 0
        deciphered_message += "0"
    end
    
    puts
    puts
    puts "Deciphered message:"
    index = 0
    
    for char in deciphered_message.to_s.chars do
        print char
        index += 1
        if index == 5
            print ' '
            index = 0
        end
    end
    
    decoded_message = ""
    
    index = 0
    encoding_chart.invert
    
    while index < (deciphered_message.to_s.length - 1) do
        value = deciphered_message.to_s.chars[index] + deciphered_message.to_s.chars[index + 1]
        
        if encoding_chart.key(value) != nil
            decoded_message += encoding_chart.key(value)
        end
        
        index += 2
    end
    
    puts
    puts
    puts "Decoded message:"
    puts decoded_message
    puts
end
