;swaps 16 bit numbers stored in memory
.model small
.stack 100h
.data
    num1 dw 1234h     ; First 16-bit number (stored in memory)
    num2 dw 5678h     ; Second 16-bit number (stored in memory)
    msg_before db 'Before swapping: ', 0Dh, 0Ah, '$'
    msg_after db 0Dh, 0Ah, 'After swapping: ', 0Dh, 0Ah, '$'
    num1_msg db 'num1 = $'
    num2_msg db 0Dh, 0Ah, 'num2 = $'
.code
main proc
    ; Initialize DS
    mov ax, @data
    mov ds, ax

    ; Display "Before swap"
    lea dx, msg_before
    mov ah, 09h
    int 21h

    ; Display num1 before swap
    lea dx, num1_msg
    mov ah, 09h
    int 21h
    mov ax, num1
    call PrintHex

    ; Display num2 before swap
    lea dx, num2_msg
    mov ah, 09h
    int 21h
    mov ax, num2
    call PrintHex

    ; SWAP PROCESS
    mov ax, num1     ; Move num1 into AX
    mov bx, num2     ; Move num2 into BX

    mov num1, bx     ; Store BX (old num2) into num1
    mov num2, ax     ; Store AX (old num1) into num2

    ; Display "After swap"
    lea dx, msg_after
    mov ah, 09h
    int 21h

    ; Display num1 after swap
    lea dx, num1_msg
    mov ah, 09h
    int 21h
    mov ax, num1
    call PrintHex

    ; Display num2 after swap
    lea dx, num2_msg
    mov ah, 09h
    int 21h
    mov ax, num2
    call PrintHex

    ; Exit program
    mov ah, 4Ch
    int 21h
main endp

; Procedure to print a 16-bit number in hexadecimal
PrintHex proc
    push ax
    push bx
    push cx
    push dx

    mov cx, 4            ; 4 hex digits
HexLoop:
    rol ax, 4            ; Rotate left 4 bits
    mov dl, al           ; Lower nibble into DL
    and dl, 0Fh          ; Mask upper bits
    cmp dl, 9
    jle PrintDigit
    add dl, 7            ; Convert 10-15 to 'A'-'F'
PrintDigit:
    add dl, '0'          ; Convert to ASCII
    mov ah, 02h          ; Print character
    int 21h
    loop HexLoop

    pop dx
    pop cx
    pop bx
    pop ax
    ret
PrintHex endp

end main