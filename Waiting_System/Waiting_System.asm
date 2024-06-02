.model small
.stack 100h

.data
    x      db 0 
    hundred1  db 0
    hundred2  db 0
    hundred3  db 0
    hundred4  db 0
    tens1  db 0
    tens2  db 0
    tens3  db 0
    tens4  db 0
    seats db 100        ; Total number of seats
    seatsTaken db 0     ; Number of seats taken
    served db 0         ; Number of customers served
    waiting db 0        ; Number of customers waiting
    newCustomer db 'n'  ; Indicator for new customer
    oldCustomer db 'o'  ; Indicator for old customer
    seatNumber db 0     ; Last assigned seat number
    msgNew db 0ah, 0dh, "New customer. Your seat number is: $"
    msgOld db 0ah, 0dh, "Old customer served. $"
    msgNoCustomer db 0ah, 0dh, "No customer to serve. $" 
    msgNoseats db 0ah, 0dh, "All Seats were taken!!! $"
    msgSeatsTaken db 0ah, 0dh, "Seats Taken: $"
    msgServed db 0ah, 0dh, "Served: $"
    msgWaiting db 0ah, 0dh, "Waiting: $"
    msgNewline db 0ah, 0dh,"$"

.code
main proc
    mov ax, @data
    mov ds, ax

processInput:
    mov ah, 1
    int 21h             ; Check for input
    cmp al, newCustomer ; New customer?
    je newCustomerInput
    cmp al, oldCustomer ; Old customer?
    je serveCustomer
    jmp processInput    ; Continue checking for input      
    
newCustomerInput:  
    cmp x, 100   ; Check if all seats were taken
    je noSeatCustomer
    inc seatNumber      ; Increment seat number
    inc seatsTaken      ; Increment number of seats taken
    inc x 
    inc waiting         ; Increment number of customers waiting
    
    call displayNewCustomerMsg
    call displaySeatNumber  
    call displaySeatsTakenMsg      
    call displaySeatsTakenNumber
    call displayServedMsg
    call displayServedNumber
    call displayWaitingMsg
    call displayWaitingNumber
    call displayNewine
    jmp processInput
    
serveCustomer:
    cmp x, 0   ; Check if any customer is served
    je noCustomer
    dec seatsTaken      ; decrement number of seats taken
    dec x
    dec waiting         ; decrement number of customers waiting  
    inc served          ; Increment number of served
    call displayOldCustomerMsg
    call displaySeatsTakenMsg      
    call displaySeatsTakenNumber
    call displayServedMsg
    call displayServedNumber
    call displayWaitingMsg
    call displayWaitingNumber
    call displayNewine
    jmp processInput        
    
noCustomer:
    call displayNoCustomerMsg
    jmp processInput 
       
noSeatCustomer:
    call displayNoSeatCustomer
    jmp processInput     
    
    
    
displayNewCustomerMsg proc
    mov ah, 9
    lea dx, msgNew
    int 21h             ; Display message for new customer
    ret
displayNewCustomerMsg endp

displaySeatsTakenMsg proc
    mov ah, 9
    lea dx,  msgSeatsTaken
    int 21h             ; Display message for msgSeatsTaken
    ret
displaySeatsTakenMsg endp 

displayServedMsg proc
    mov ah, 9
    lea dx, msgServed
    int 21h             ; Display message for msgServed
    ret
displayServedMsg endp 

displayWaitingMsg proc
    mov ah, 9
    lea dx, msgWaiting
    int 21h             ; Display message for msgWaiting
    ret
displayWaitingMsg endp

displayNewine proc
    mov ah, 9
    lea dx, msgNewline
    int 21h             ; Display message for new line
    ret
displayNewine endp

displayOldCustomerMsg proc
    mov ah, 9
    lea dx, msgOld
    int 21h             ; Display message for old customer
    ret
displayOldCustomerMsg endp

displayNoCustomerMsg proc
    mov ah, 9
    lea dx, msgNoCustomer
    int 21h             ; Display message if no customer is served
    ret
displayNoCustomerMsg endp

displayNoSeatCustomer proc
    mov ah, 9
    lea dx, msgNoseats
    int 21h             ; Display message if no customer is served 
    call displayNewine
    ret
displayNoSeatCustomer endp

j1 proc
    sub seatNumber,10 
    inc tens1
    call displaySeatNumber
    ret
j1 endp

hi1 proc
    sub tens1,10 
    inc hundred1  
    call displaySeatNumber
    ret
hi1 endp 
reset1 proc
    cmp seatNumber,1
    jz  reset2
    jmp j
    ret
reset1 endp 

reset2 proc
    mov hundred1,0
    call displaySeatNumber
    ret
reset2 endp
    
   

displaySeatNumber proc
    cmp tens1,10
    jz  hi1 
    cmp seatNumber,10
    jz  j1
    cmp hundred1,1
    jz  reset1
j:
    mov ah, 2
    mov dl, hundred1
    add dl, '0'
    int 21h
    
    mov ah, 2
    mov dl, tens1
    add dl, '0'
    int 21h 
    
    mov ah, 2
    mov dl, seatNumber
    add dl, '0'
    int 21h             ; Display seat number
    ret
displaySeatNumber endp  

j2 proc
    sub seatsTaken,10 
    inc tens2 
    call displaySeatsTakenNumber
    ret
j2 endp
    
d1 proc
    add seatsTaken,10 
    dec tens2
    call displaySeatsTakenNumber
    ret
d1 endp 

hi2 proc
    sub tens2,10 
    inc hundred2  
    call displaySeatsTakenNumber
    ret
hi2 endp 

hd proc
    add tens2,10 
    dec hundred2 
    call displaySeatsTakenNumber
    ret
hd endp


displaySeatsTakenNumber proc 
    cmp tens2,10   
    jz  call hi2
      
    cmp tens2,0ffh   
    jz  call hd
    
    cmp seatsTaken,10
    jz  j2 
    cmp seatsTaken,0ffh 
    jz call d1 
    
    mov ah, 2
    mov dl, hundred2
    add dl, '0'
    int 21h
    
    mov ah, 2 
    mov dl, tens2
    add dl, '0'
    int 21h
    mov ah, 2
    mov dl, seatsTaken
    add dl, '0'
    int 21h             ; Display seatsTaken number
    ret
displaySeatsTakenNumber endp  

j3 proc
    sub served,10 
    inc tens3 
    call displayServedNumber
    ret
j3 endp

hi3 proc
    sub tens3,10 
    inc hundred3  
    call displayServedNumber
    ret
hi3 endp 


displayServedNumber proc 
    
    cmp tens3,10
    jz  hi3
   
    cmp served,10
    jz  j3 
    
    mov ah, 2
    mov dl, hundred3
    add dl, '0'
    int 21h
     
    mov ah, 2
    mov dl, tens3
    add dl, '0'
    int 21h 
    
    mov ah, 2
    mov dl, served
    add dl, '0'
    int 21h             ; Display served number
    ret
displayServedNumber endp  

j4 proc
    sub waiting,10 
    inc tens4  
    call displayWaitingNumber
    ret
j4 endp

d2 proc
    add waiting,10 
    dec tens4 
    call displayWaitingNumber
    ret
d2 endp

hi4 proc
    sub tens4,10 
    inc hundred4  
    call displayWaitingNumber
    ret
hi4 endp 

hd2 proc
    add tens4,10 
    dec hundred4 
    call displayWaitingNumber
    ret
hd2 endp

displayWaitingNumber proc 
    cmp tens4,10   
    jz  call hi4
      
    cmp tens4,0ffh   
    jz  call hd2
    
    cmp waiting,10   
    jz  call j4
      
    cmp waiting,0ffh   
    jz  call d2
    mov ah, 2
    mov dl, hundred4
    add dl, '0'
    int 21h
    mov ah, 2
    mov dl, tens4
    add dl, '0'
    int 21h
    mov ah, 2
    mov dl, waiting
    add dl, '0'
    int 21h             ; Display waiting number
    ret
displayWaitingNumber endp 

CODE    ENDS
        END    main