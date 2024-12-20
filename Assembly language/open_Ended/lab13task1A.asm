;1. Write a program that will perform following tasks using procedure from the link library.
;a. Input 32-bit integer from user and display it in decimal, hexadecimal andbinary.
; Correctly display integer in Decimal, Hexadecimal, and Binary
.model small
.stack 100h
.data
  prompt db 'Enter a 32-bit integer: $'
  decimal db 13, 10, 'Decimal: $'
  hex db 13, 10, 'Hexadecimal: $'
  binary db 13, 10, 'Binary: $'

.code
main proc
    mov ax, @data    ; Initialize DS
    mov ds, ax

    ; Prompt user
    lea dx, prompt
    mov ah, 09h
    int 21h

    ; Read input
    call ReadInteger

    ; Decimal display
    lea dx, decimal
    mov ah, 09h
    int 21h
    call PrintDecimal

    ; Hexadecimal display
    lea dx, hex
    mov ah, 09h
    int 21h
    call PrintHex

    ; Binary display
    lea dx, binary
    mov ah, 09h
    int 21h
    call PrintBinary

    ; End program
    mov ah, 4Ch
    int 21h
main endp

; Reads a decimal integer input
ReadInteger proc
    xor ax, ax
    xor bx, bx
    mov cx, 10       ; Base 10
ReadLoop:
    mov ah, 01h      ; Read character
    int 21h
    cmp al, 0Dh      ; Enter key ends input
    je DoneRead
    sub al, '0'      ; Convert ASCII to integer
    mul cx           ; Multiply previous result by 10
    add bx, ax       ; Add new digit
    xor ax, ax
    jmp ReadLoop
DoneRead:
    mov ax, bx       ; Result in AX
    ret
ReadInteger endp

; Print Decimal number
PrintDecimal proc
    mov bx, 10
    xor cx, cx       ; Clear CX for stack
DecLoop:
    xor dx, dx       ; Clear DX for remainder
    div bx           ; AX / 10, remainder in DX
    push dx          ; Save remainder
    inc cx           ; Increment digit count
    test ax, ax
    jnz DecLoop
PrintLoop:
    pop dx
    add dl, '0'      ; Convert remainder to ASCII
    mov ah, 02h
    int 21h
    loop PrintLoop
    ret
PrintDecimal endp

; Print Hexadecimal number
PrintHex proc
    mov bx, 16
    xor cx, cx
HexLoop:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz HexLoop
HexPrint:
    pop dx
    cmp dl, 9        ; Check if > 9 for A-F
    jle HexDigit
    add dl, 7        ; Adjust for A-F
HexDigit:
    add dl, '0'      ; Convert to ASCII
    mov ah, 02h
    int 21h
    loop HexPrint
    ret
PrintHex endp

; Print Binary number
PrintBinary proc
    mov bx, 2
    xor cx, cx
BinLoop:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz BinLoop
BinPrint:
    pop dx
    add dl, '0'      ; Convert to ASCII
    mov ah, 02h
    int 21h
    loop BinPrint
    ret
PrintBinary endp

end main