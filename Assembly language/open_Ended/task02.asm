.model small
.stack 100h

.data
    prompt db "Enter a 32-bit integer: $"
    result db "You entered: $"
    input db 11 dup(0)            ; Buffer for user input (max 10 digits + null terminator)
    number dd 0                   ; Variable to store the 32-bit integer

.code
main proc
    ; Initialize the data segment
    mov ax, @data
    mov ds, ax

    ; Prompt user for input
    lea dx, prompt
    mov ah, 09h
    int 21h

    ; Read input
    lea dx, input
    mov ah, 0Ah                  ; Input function
    int 21h

    ; Convert input string to integer
    lea si, input + 1            ; Skip length byte
    xor eax, eax                 ; Clear EAX for the result
    xor ecx, ecx                 ; Multiplier
    mov ecx, 10                  ; Base 10 multiplier

ConvertLoop:
    movzx edx, byte ptr [si]     ; Load a byte
    cmp dl, 0Dh                  ; Check for carriage return (end of input)
    je StoreNumber               ; If end, jump to store number
    sub dl, '0'                  ; Convert ASCII to numeric
    imul eax, ecx                ; Multiply existing result by 10
    add eax, edx                 ; Add the new digit
    inc si                       ; Move to the next character
    jmp ConvertLoop              ; Repeat

StoreNumber:
    mov number, eax              ; Store the 32-bit result in 'number'

    ; Display the result
    lea dx, result
    mov ah, 09h
    int 21h

    mov eax, number              ; Load the 32-bit integer
    call PrintNumber             ; Print it

    ; Exit program
    mov ah, 4Ch
    int 21h

; Procedure to print a 32-bit number
PrintNumber proc
    ; Input: EAX contains the number
    push ax                      ; Save AX
    push bx                      ; Save BX
    push cx                      ; Save CX
    push dx                      ; Save DX

    xor ecx, ecx                 ; Clear CX (digit count)
    mov ebx, 10                  ; Divisor for decimal conversion

convertLoop:
    xor edx, edx                 ; Clear high part for division
    div ebx                      ; EAX = EAX / 10, EDX = remainder
    push dx                      ; Save the remainder (digit)
    inc ecx                      ; Increment digit count
    test eax, eax                ; Check if EAX is zero
    jnz convertLoop              ; Repeat until EAX == 0

printLoop:
    pop dx                       ; Get next digit
    add dl, '0'                  ; Convert to ASCII
    mov ah, 02h                  ; Print character
    int 21h
    loop printLoop               ; Repeat for all digits

    pop dx                       ; Restore DX
    pop cx                       ; Restore CX
    pop bx                       ; Restore BX
    pop ax                       ; Restore AX
    ret
PrintNumber endp

main endp
end main
