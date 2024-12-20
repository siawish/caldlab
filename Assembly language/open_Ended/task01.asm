.model small
.stack 100h

.data
    message db "welcome assembly language", 13, 10, "$"

.code
main proc
    mov ax, @data      ; Load data segment address into AX
    mov ds, ax         ; Move AX into DS to initialize data segment

    ; Print the message
    lea dx, message    ; Load the address of the message into DX
    mov ah, 09h        ; DOS interrupt to display a string
    int 21h            ; Call DOS interrupt

    ; Exit program
    mov ah, 4Ch        ; DOS interrupt to terminate program
    int 21h            ; Call DOS interrupt
main endp

end main
