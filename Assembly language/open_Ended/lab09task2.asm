.model small
.stack 100h

.data
ARRAY1 db 5, 10, 15, 20, 25       ; Source array
ARRAY2 db 5 dup(?)                ; Destination array
ARRAYSIZE dw 5                    ; Size of the arrays
SUCCESSMSG db "Copied Successfully to Another Array!$", 0

.code
main proc                         ; Entry point for the program
    mov ax, @data                 ; Initialize data segment
    mov ds, ax

    ; Initialize source and destination indexes
    xor si, si                    ; SI points to ARRAY1 (source)
    xor di, di                    ; DI points to ARRAY2 (destination)
    mov cx, ARRAYSIZE             ; CX = size of the array

copyLoop:
    mov al, [ARRAY1 + si]         ; Load value from ARRAY1
    mov [ARRAY2 + di], al         ; Store value into ARRAY2
    inc si                        ; Increment source index
    inc di                        ; Increment destination index
    loop copyLoop                 ; Loop until all elements are copied

    ; Display success message
    lea dx, SUCCESSMSG
    mov ah, 09h                   ; DOS function to display string
    int 21h

    ; Exit the program
    mov ah, 4Ch                   ; DOS function to exit program
    int 21h                       ; Call DOS interrupt
main endp

end main                          ; End of program and specify entry point