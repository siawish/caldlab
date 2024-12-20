.model small
.stack 100h
.data
    random_msg db 'Random numbers: $'
    newline db 0Dh, 0Ah, '$'
    seed dw 1234h ; Initial seed value
.code
main proc
    mov ax, @data
    mov ds, ax

    lea dx, random_msg
    mov ah, 09h
    int 21h

    mov cx, 10      ; Loop counter

random_loop:
    ; Linear Congruential Generator (LCG) - Corrected for 16-bit
    mov ax, seed    ; Load the seed
    mov dx, 0       ; Clear DX (important for 16-bit multiplication)

    ; Perform 16-bit multiplication correctly
    mov bx, 16645   ; Use a 16-bit multiplier
    mul bx          ; AX * BX = DX:AX (32-bit result)

    ; Handle the upper word of the multiplication if needed for a longer period
    push dx ; Store upper word of the result (DX) if you need a longer period
    
    add ax, 10139   ; Use a 16-bit increment
    mov seed, ax    ; Store the new seed (lower 16 bits of the result)

    ; Limit the number to range [0, 20] using modulo
    mov bx, 21
    xor dx, dx
    div bx          ; Remainder in DX (0-20)

    ; Convert to ASCII and print (same as before)
    mov al, dl
    cmp al, 10
    jl single_digit

    xor ah, ah
    mov bl, 10
    div bl
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h

    mov al, ah
    add al, '0'
    mov dl, al
    int 21h
    jmp print_space

single_digit:
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h

print_space:
    mov dl, ' '
    mov ah, 02h
    int 21h

    pop dx ;Restore DX after printing the number
    dec cx
    jnz random_loop

    lea dx, newline
    mov ah, 09h
    int 21h

    mov ah, 4Ch
    int 21h
main endp
end main