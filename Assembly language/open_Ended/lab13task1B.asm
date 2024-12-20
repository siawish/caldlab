;display cpu registers
.model small
.stack 100h
.data
    reg_msg db 'Registers:', 0Dh, 0Ah, '$'
    eax_msg db 'AX: $'
    ebx_msg db 0Dh, 0Ah, 'BX: $'
    ecx_msg db 0Dh, 0Ah, 'CX: $'
    edx_msg db 0Dh, 0Ah, 'DX: $'
    newline db 0Dh, 0Ah, '$'

.code
main proc
    ; Initialize the data segment
    mov ax, @data
    mov ds, ax

    ; Display "Registers:"
    lea dx, reg_msg
    mov ah, 09h
    int 21h

    ; Display AX register
    call PrintNewline
    lea dx, eax_msg
    mov ah, 09h
    int 21h
    mov ax, 1234h    ; Example value for AX
    call PrintHex

    ; Display BX register
    call PrintNewline
    lea dx, ebx_msg
    mov ah, 09h
    int 21h
    mov bx, 5678h    ; Example value for BX
    mov ax, bx       ; Move BX to AX for printing
    call PrintHex

    ; Display CX register
    call PrintNewline
    lea dx, ecx_msg
    mov ah, 09h
    int 21h
    mov cx, 9ABCh    ; Example value for CX
    mov ax, cx       ; Move CX to AX for printing
    call PrintHex

    ; Display DX register
    call PrintNewline
    lea dx, edx_msg
    mov ah, 09h
    int 21h
    mov dx, 0DEF0h   ; Example value for DX
    mov ax, dx       ; Move DX to AX for printing
    call PrintHex

    ; End program
    mov ah, 4Ch
    int 21h
main endp

; Procedure to print a 16-bit number in hexadecimal
PrintHex proc
    push ax          ; Save AX
    push bx          ; Save BX
    push cx          ; Save CX
    push dx          ; Save DX

    mov cx, 4        ; 4 hex digits to display
HexLoop:
    rol ax, 4        ; Rotate left 4 bits
    mov dl, al       ; Lower nibble into DL
    and dl, 0Fh      ; Mask upper bits
    cmp dl, 9
    jle PrintDigit
    add dl, 7        ; Adjust for letters A-F
PrintDigit:
    add dl, '0'      ; Convert to ASCII
    mov ah, 02h
    int 21h          ; Print character
    loop HexLoop

    pop dx           ; Restore registers
    pop cx
    pop bx
    pop ax
    ret
PrintHex endp

; Procedure to print a new line
PrintNewline proc
    lea dx, newline
    mov ah, 09h
    int 21h
    ret
PrintNewline endp

end main