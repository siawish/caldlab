.model small
.stack 100h
.data
array db 5, 10, 15, 20, 25 ; Array of integers
arraySize dw 5 ; Size of the array
sum dw 0 ; Variable to store the sum
avg dw 0 ; Variable to store the average
msgSum db "Sum: $"
msgAvg db "Average: $"
.code
main proc
mov ax, @data
mov ds, ax
; Initialize sum to 0
mov cx, arraySize
xor bx, bx ; Index
xor ax, ax ; Clear AX for sum
sumLoop:
add al, [array + bx] ; Add array element to AX
inc bx ; Move to next element
loop sumLoop
; Store sum
mov sum, ax
; Calculate average
mov cx, arraySize
xor dx, dx ; Clear DX for division
div cx ; AX = AX / CX, DX = remainder
mov avg, ax ; Store average
; Display sum
lea dx, msgSum
mov ah, 09h
int 21h
mov ax, sum
call PrintNumber
; Display average
lea dx, msgAvg
mov ah, 09h
int 21h
mov ax, avg
call PrintNumber
; Exit program
mov ah, 4Ch
int 21h
PrintNumber proc
; Print AX as a decimal number
push ax
xor cx, cx
mov bx, 10
convertLoop:
xor dx, dx
div bx
push dx
inc cx
test ax, ax
jnz convertLoop
printLoop:
pop dx
add dl, '0'
mov ah, 02h
int 21h
loop printLoop
pop ax
ret
PrintNumber endp
main endp
end main