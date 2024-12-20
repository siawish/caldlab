.model small
.stack 100h
.data
    UARRAY DW 1000h, 2000h, 3000h, 4000h   ; Define a WORD array
    msg_before db 'Register values before assignment:', 0Dh, 0Ah, '$'
    msg_after  db 0Dh, 0Ah, 'Register values after assignment:', 0Dh, 0Ah, '$'
    ax_msg     db 'AX = ', '$'
    bx_msg     db 0Dh, 0Ah, 'BX = ', '$'
    cx_msg     db 0Dh, 0Ah, 'CX = ', '$'
    dx_msg     db 0Dh, 0Ah, 'DX = ', '$'

.code
main proc
    ; Initialize Data Segment
    mov ax, @data
    mov ds, ax

    ; Display message before assignment
    lea dx, msg_before
    mov ah, 09h
    int 21h

    ; Dump initial register values
    call DumpRegs

    ; Move values from UARRAY into registers using direct-offset addressing
    mov ax, UARRAY         ; Load first value (1000h) into AX
    mov bx, UARRAY[2]      ; Load second value (2000h) into BX
    mov cx, UARRAY[4]      ; Load third value (3000h) into CX
    mov dx, UARRAY[6]      ; Load fourth value (4000h) into DX

    ; Display message after assignment
    lea dx, msg_after
    mov ah, 09h
    int 21h

    ; Dump register values after assignment
    call DumpRegs

    ; Exit program
    mov ah, 4Ch
    int 21h
main endp

; Custom DumpRegs Procedure to Display AX, BX, CX, and DX
DumpRegs proc
    ; Display AX
    lea dx, ax_msg
    mov ah, 09h
    int 21h
    call PrintHex     ; Print AX in hexadecimal

    ; Display BX
    lea dx, bx_msg
    mov ah, 09h
    int 21h
    mov ax, bx        ; Move BX to AX for printing
    call PrintHex

    ; Display CX
    lea dx, cx_msg
    mov ah, 09h
    int 21h
    mov ax, cx
    call PrintHex

    ; Display DX
    lea dx, dx_msg
    mov ah, 09h
    int 21h
    mov ax, dx
    call PrintHex

    ret
DumpRegs endp

; Procedure to Print a 16-bit Value in Hexadecimal
PrintHex proc
    push ax
    push bx
    push cx
    push dx

    mov cx, 4          ; 4 hex digits to print
HexLoop:
    rol ax, 4          ; Rotate left to get next hex digit
    mov dl, al
    and dl, 0Fh        ; Mask the lower 4 bits
    add dl, '0'        ; Convert to ASCII
    cmp dl, '9'        ; Check if it is 0-9 or A-F
    jbe PrintDigit
    add dl, 7          ; Adjust for A-F
PrintDigit:
    mov ah, 02h        ; DOS print character
    int 21h
    loop HexLoop       ; Repeat for next digit

    pop dx
    pop cx
    pop bx
    pop ax
    ret
PrintHex endp

end main