bits 16
[ORG 0x7C00]
        START:
        cli
	xor ax,ax
	mov ds,ax
	mov es,ax
        mov edi, 0xB8000
        read:
            mov byte[edi], '!'
            add edi, 2
            mov ax, OS   ; ES:BX = 1000h:0000
            mov es, ax          ;
            xor bx, bx          ;
            mov ah, 2           ; Load disk data to ES:BX
            mov al, 30          ; Load 5 sectors
            mov ch, 0           ; Cylinder=0
            mov cl, 2           ; Sector=2
            mov dh, 0           ; Head=0
            ;mov dl, 0            ; Drive=0
            int 13h             ; Read!
            jc read             ; ERROR => Try again
            mov byte[edi], 'L'
            add edi, 2
            jmp OS:0h      ; Jump to the program
        hlt
        
    
    inv:db 'Invalid Cmd.',0
    scanTable: db "//1234567890-=//QWERTYUIOP~~//ASDFGHJKL;//'/ZXCVBNM,.//// /",0
    snakeString:db 'SNAKE',0
    notepadString:db 'NOTEPAD',0
    calculatorString:db 'CALCULATOR',0
    pongString:db 'PONG',0
    painterString:db 'PAINTER',0
    
    arr: db '>> ',0
    ans: db 'ans = ',0
    ;ststring: db ' Started!',0
    welcomeString: db 'Welcome',0
    p:db 0
    ;ans: db 'ans - ',0
    nums: db '0123456789',0
    ops: db '+-*/^',0
    
    
    format: db 'ans = %d'
    ten: dd 10
    ;scanTable3: db"//1234567890-=//QWERTYUIOP[]//ASDFGHJKL;//'/ZXCVBNM,.//// /",0
    
    ;scanTable2: db '//!@#$%^&*()_+//QWERTYUIOP{}//ASDFGHJKL://"/ZXCVBNM<>?/// /',0
    infinte: db 'inf',0
    ;PONG DATA
    
    player: db 'Player ', 0
    won: db ' won!', 0
    md: db 'Game mode: ',0
    PvsP: db 'f';'   Player vs. Player w>',0
    PvsC: db '<s Player vs. computer ', 0
    difP: db 'Game Speed: ',0
    slow: db '   slow   d>',0
    medium: db '<a Medium d>',0
    fast: db '<a  fast  d>',0
    Vfast: db '<a very fast   ',0
    comwon: db 'Computer Won!',0
    ;SNAKE DATA
    
    welcome: db 'f',0;'Welcome!',0
    mdS: db 'f',0;'Game mode: ',0
    mww: db 'f',0;'   With walls s>',0
    mwow: db 'f',0;'<w Without walls ', 0
    dif: db 'f',0;'Difficulty: ',0
    easy: db 'f',0;'   Easy   d>',0
    med: db 'f',0;'<a Medium d>',0
    hard: db 'f',0;'<a  Hard  d>',0
    insane: db 'f',0;'<a Insane   ',0
    gameoverstring: db'f',0;'GAME OVER!',0
    scoreString: db 'f',0;'Score: ',0
    waiting: db 'f',0;'Press ENTER to continue...',0
    
    
    ;lastPixelColor: db 0x0f
lastPixelColor1: db 0x0f
lastPixelColor2: db 0x0f
lastPixelColor3: db 0x0f
    black: db 0
blue: db 1
green: db 2
cyan: db 3
red: db 4
magenta: db 5
brown: db 6
lightGray: db 7
gray: db 8
lightBlue: db 9
lightGreen: db 10
lightCyan: db 11
lightRed: db 12
lightMagenta: db 13
yellow: db 14
white: db 15
	
statusMouse: dw 0
leftButtonMouse: db 0,0
rightButtonMouse: db 0,0	  	
xMouse: dw 0      
yMouse: dw 0
zMouse: dw 0
lastPixelColor: db 0x0f
currentColor: db 0x00
temporaryColor: db 0
initialCurrentColor: db 0x00
currentAuxilaryColor: db 0x03
rightButtonColor: db 0

currentShape: dw 0 ; 0 pen, 1 line, 2 rectangle, 3 circle
shapesColor: db 1
drawAvailability: db 1
	
blackX: 
orangeX: dw 303
redX:
greenX: dw 287
blueX: 
cianX: dw 271
blackY: 
redY:
blueY:
currentColorY:
penY:
lineY:
currentShapeY: dw 3
orangeY:
greenY:
cianY:
currentAuxilaryColorY: 
rectangleY:
circleY:dw 18
currentColorX: 
currentAuxilaryColorX: dw 250
lineX:
rectangleX: dw 229
circleX:
penX: dw 213
currentShapeX: dw 193


xFilledPen: dw 0
yFilledPen: dw 0


xdot: dw 0
ydot: dw 0

xRect: dw 0,0,0
yRect: dw 0,0,0
drawMode: db 0
penDrawMode: db 0

colorSquareLength: dw 14
leftmostPixel: dw 190
lowestPixel: dw 40

drawHorizontalRectangleCounter: dw 0
maximumRadius : dd 6
    
times 510-($-$$) db 0
dw 0AA55h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
OS:
bla:
        cli
        mov bx, scanTable
        call ClearScreen
        mov si, welcomeString
        call printString
        ;jmp $
        mov edi, 0xB80A0
        mov si, arr
        call printString
        mov ecx, -1
        chk:
        IN al, 0x64
        and al, 1
        jz chk
        IN al, 0x60
        cmp al,0x80
        jae chk
        cmp al, 0x1C;enter key
        je enterApp
        xlat
        inc ecx
        mov byte[command+ecx], al
        shl ecx, 1
        mov byte[edi+ecx], al
        shr ecx, 1
        jmp chk
        enterApp:;
        XOR ESI, ESI
        XOR EDI, EDI
        mov si, command
        mov di, snakeString
        call cmpString
        and ax, 1
        jz next1
        mov cl, 2
        jmp Snake
        next1:
        mov si, command
        mov di, notepadString
        call cmpString
        and ax, 1
        jz next2
        mov cl, 4
        jmp NotePad
        next2:
        mov si, command
        mov di, calculatorString
        call cmpString
        and ax, 1
        jz next3
        mov cl, 6
        jmp Calculator
        next3:
        mov si, command
        mov di, pongString
        call cmpString
        and ax, 1
        jz next4
        mov cl, 8
        jmp Pong
        next4:
        mov si, command
        mov di, painterString;;;;;
        call cmpString
        and ax, 1
        jz next5
        mov cl, 10
        jmp Painter
        next5:
        mov edi, 0xB8140
        mov si, inv
        call printString
        l:
        in al, 0x64
        and al, 1
        jz l
        in al, 0x60
        cmp al, 0x1C
        jne l
        mov ecx, -1
        lll:
        inc ecx
        cmp ecx, 15
        jge bla
        mov byte[command+ecx], 0
        jmp lll
times 1024-($-OS) db 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Snake:
    cli
    call ClearScreen
    call welcomeScreen2
    call SetupS
    mov byte[gameOver], 'f'
    call DrawBorder
    call ClearScreenInside
    loopinfS:
    call game1
    cmp byte[gameOver], 't'
    je QUIT_SNAKE
    jmp loopinfS
welcomeScreen2:
    call ClearScreen
    mov si, welcome
    call printString
    jmp printscrn
    l1:
    in al, 0x64
    and al, 1
    jz l1
    in al, 0x60
    cmp al, 0x11;w
    jne L2
    mov dword[mode], 1
    jmp printscrn
    L2:
    cmp al, 0x1E;a
    jne L3
    cmp dword[d], 4
    jge printscrn
    inc dword[d]
    jmp printscrn
    L3:
    cmp al, 0x1F;s
    jne L4
    mov dword[mode], 0
    jmp printscrn
    L4:
    cmp al, 0x20;d
    jne endl
    cmp dword[d], 1
    jle printscrn
    dec dword[d]
    jmp printscrn
    endl:
    cmp al, 0x1C
    jne printscrn
    ret
    printscrn:
    mov edi, 0xB80A0
    mov si, mdS
    call printString
    cmp dword[mode], 1
    jne m1
    mov si, mww
    call printString
    jmp m2
    m1:
    mov si, mwow
    call printString
    m2:
    mov edi, 0xB8140
    mov si, dif
    call printString
    cmp dword[d], 4
    jne d1
    mov si, easy
    call printString
    jmp d4
    d1:
    cmp dword[d], 3
    jne d2
    mov si, med
    call printString
    jmp d4
    d2:
    cmp dword[d], 2
    jne d3
    mov si, hard
    call printString
    jmp d4
    d3:
    mov si, insane
    call printString
    d4:
    mov edi, 0xB80A0
    add edi, 320
    mov si, waiting
    call printString
    
    jmp l1
SetupS:
    mov ecx, -1
    ls:
    inc ecx
    cmp ecx, dword[nTail]
    je ens
    mov dword[tailX+ecx*4], 0
    mov dword[tailY+ecx*4], 0
    jmp ls
    ens:
    mov dword[nTail], 3
    mov dword[x], 40
    mov dword[y], 12
    FF1:
    mov ecx, 1
    mov edx, 79
    call GENRAND
    mov dword[fruitX], eax
    cmp eax, 1
    jbe FF1
    cmp eax, 79
    jae FF1
    FF2:
    mov ecx, 1
    mov edx, 24
    call GENRAND
    mov dword[fruitY], eax
    mov dword[scoreS], 0
    cmp eax, 1
    jbe FF2
    cmp eax, 24
    jae FF2
    ;jmp l
    ret
DrawBorder:
    call ClearScreen
    mov ecx, -1
    loopQS:
    inc ecx
    cmp ecx, 25
    jge endQS
    mov ebx, -1
        loopQS2:
        inc ebx
        cmp ebx, 80
        jge loopQS
        cmp ecx, 0
        jne G1
        mov byte[edi], '#'
        add edi, 2
        jmp loopQS2
        G1:
        cmp ebx, 0
        jne G2
        mov byte[edi], '#'
        add edi, 2
        jmp loopQS2
        G2:
        cmp ebx, 79
        jne G3
        mov byte[edi], '#'
        add edi, 2
        jmp loopQS2
        G3:
        cmp ecx, 24
        jne endQS2
        mov byte[edi], '#'
        add edi, 2
        jmp loopQS2
        endQS2:
        add edi, 2
        jmp loopQS2
    endQS:
    ret
DrawS:
    ;call ClearScreenInside
    mov edi, 0xB8000
    mov ecx, -1
    mov ebx, -1
    loopS1:
        inc ecx
        cmp ecx, 25
        jge endS1
        mov ebx, -1
        loopS2:
            inc ebx
            cmp ebx, 80
            jge loopS1
            cmp ecx, 0
            je o2
            cmp ecx, 24
            je o2
            cmp ebx, 0
            je o2
            cmp ebx, 79
            je o2
            cmp ecx, dword[fruitY]
            je o3
            o31:
            cmp ecx, dword[y]
            je o4
            o41:
            mov esi, -1
            loop7:
                inc esi
                cmp esi, dword[nTail]
                jge o1
                cmp dword[tailX+esi*4], ecx
                jne loop7
                cmp dword[tailY+esi*4], ebx
                jne loop7
                mov byte[edi], 'o'
                add edi, 2
                jmp loopS2
            end7:
            o1:                        
            mov byte[edi], ' '
            add edi, 2
            jmp loopS2
            o2:
            add edi, 2
            jmp loopS2
            o3:
            cmp ebx, dword[fruitX]
            jne o31
            mov byte[edi], 1
            add edi, 2
            jmp loopS2
            o4:
            cmp ebx, dword[x]
            jne o41
            mov byte[edi], 'O'
            add edi, 2
            jmp loopS2
    endS1:
    mov edi, 0xB8000
    mov eax, 160
    mov ebx, 24
    mul ebx
    add edi, eax
    add edi, 70
    mov byte[edi], 'S'
    add edi, 2
    mov byte[edi], 'C'
    add edi, 2
    mov byte[edi], 'O'
    add edi, 2
    mov byte[edi], 'R'
    add edi, 2
    mov byte[edi], 'E'
    add edi, 2
    mov byte[edi], ':'
    add edi, 2
    mov byte[edi], ' '
    add edi, 2
    mov eax, dword[scoreS]
    call printNum
    ret
LogicS:
    ;mov eax, 80
;    mov ebx, 25
;    mul ebx
;    cmp eax, [nTail]
;    ;jle NOWAY
    ;
    
    


    ;
    mov eax, dword[tailX]
    mov dword[prevX], eax
    mov eax, dword[tailY]
    mov dword[prevY], eax
    mov eax, dword[y]
    mov dword[tailX], eax
    mov eax, dword[x]
    mov dword[tailY], eax
    mov ecx, 0
    loop1S:
        inc ecx
        cmp ecx, dword[nTail]
        jge end1S
        mov eax, dword[tailX+ecx*4]
        mov dword[prev2X], eax
        mov eax, dword[tailY+ecx*4]
        mov dword[prev2Y], eax
        mov eax, dword[prevX]
        mov dword[tailX+ecx*4], eax
        mov eax, dword[prevY]
        mov dword[tailY+ecx*4], eax
        mov eax, dword[prev2X]
        mov dword[prevX], eax
        mov eax, dword[prev2Y]
        mov dword[prevY], eax
        jmp loop1S
    end1S:
    cmp byte[dir], 'l'
    je left
    cmp byte[dir], 'r'
    je right
    cmp byte[dir], 'u'
    je up
    inc dword[y]
    jmp e
    left: dec dword[x]
    jmp e
    right: inc dword[x]
    jmp e
    up: dec dword[y]
    e:
    mov eax, [x]
    cmp eax, 79
    jg n1
    cmp eax, 1
    jl n1
    mov eax, [y]
    cmp eax, 24
    jg n1
    cmp eax, 1
    jl n1
    jmp n2
    n1:
    cmp dword[mode], 1
    jne n2
    mov byte[gameOver], 't'
    n2:
    ;cmp dword[mode], 0
    ;jne n3
    ;
    mov eax, [x]
    cmp eax, 79
    jnge n21
    mov dword[x], 1
    n21:
    cmp eax, 1
    jnl n22
    mov ebx, 79
    mov [x], ebx
    n22:
    mov eax, [y]
    cmp eax, 24
    jnge n23
    mov dword[y], 1
    n23:
    cmp eax, 1
    jnl n24
    mov ebx, 24
    mov [y], ebx
    n24: 
    mov ecx, -1
    loop2:
        inc ecx
        cmp ecx, [nTail]
        jge end2
        mov eax, [tailX+ecx*4]
        cmp eax, [y]
        jne loop2
        mov eax, [tailY+ecx*4]
        cmp eax, [x]
        je over
        jmp loop2
    over:
    mov byte[gameOver], 't'
    end2:
    mov eax, [fruitX]
    cmp eax, [x]
    jne n3
    mov eax, [fruitY]
    cmp eax, [y]
    jne n3
    ;mov eax, [mode]
;    shl eax, 1
;    add eax, [difficulty]
;    mov ebx, 10
;    mul ebx
;    add eax, 10
    mov eax, dword[d]
    sub eax, 4
    neg eax
    inc eax
    mov ebx, eax
    mov eax, dword[mode]
    inc eax
    mul ebx
    add dword[scoreS], eax
    inc dword[nTail]
    ;
    F1:
    mov cx, 1
    mov dx, 79
    call GENRAND
    movzx eax, ax
    mov dword[fruitX], eax
    cmp eax, 1
    jbe F1
    cmp eax, 79
    jae F1
    ;
    F2:
    mov cx, 1
    mov dx, 24
    call GENRAND
    movzx eax, ax
    mov dword[fruitY], eax
    cmp eax, 1
    jbe F2
    cmp eax, 24
    jae F2
    
    n3:
;    mov ecx, -1
;    loopF:
;    inc ecx
;    cmp ecx, dword[nTail]
;    jge F
;    mov eax, dword[tailX+ecx*4]
;    cmp dword[fruitX], eax
;    jne loopF
;    mov eax, dword[tailY+ecx*4]
;    cmp dword[fruitY], eax
;    jne loopF
;    jmp gen
;    F:
;    cmp dword[fruitX], 1
;    jl gen
;    cmp dword[fruitY], 1
;    jl gen
;    cmp dword[fruitX], 79
;    jg gen
;    cmp dword[fruitY], 24
;    jg gen
;    mov eax, dword[x]
;    cmp dword[fruitX], eax
;    jne g
;    mov eax, dword[y]
;    cmp dword[fruitY], eax
;    je gen
;    g:
;    ret
;    gen:
;    mov dword[fruitX], 40
;    mov dword[fruitY], 12
    ret
InputS:
    IN al, 0x64
    and al, 1
    jz return1
    IN al, 0x60
    cmp al, 0x11;make code of 'w'
    jne i1
    cmp byte[dir], 'd'
    je i4
    mov byte[dir], 'u'
    jmp ii
    i1:
    cmp al, 0x1E;a
    jne i2
    cmp byte[dir], 'r'
    je i4
    mov byte[dir], 'l'
    jmp ii
    i2:
    cmp al, 0x1F;s
    jne i3
    cmp byte[dir], 'u'
    je i4
    mov byte[dir], 'd'
    jmp ii
    i3:
    cmp al, 0x20;d
    jne ii
    cmp byte[dir], 'l'
    je i4
    mov byte[dir], 'r'
    ii:
    cmp al, 0x01;esc
    jne i4
    jmp OS
    i4:
    ;could also add pause by pressing 'p'
    return1:
    ret
game1:
    call InputS
    call LogicS
    call DrawS
    call SleepS
    ret
SleepS:
    mov eax, 2500000
    mov ebx, dword[d]
    inc ebx
    mul ebx
    mov ecx, eax
    xor eax, eax
    loopSleepS:
    inc eax
    cmp eax, ecx
    jl loopSleepS
    ret
QUIT_SNAKE:
         call ClearScreen
         mov si, gameoverstring
         call printString
         mov edi, 0xB80A0
         mov si, scoreString
         call printString
         mov eax, dword[scoreS]
         call printNum
         mov edi, 0xB80A0
         add edi, 160
         mov si, waiting
         call printString
         l3:
         in al, 0x64
         and al, 1
         jz l3
         in al, 0x60
         cmp al, 0x1C
         je OS
         jmp l3
    ClearScreenInside:
    ;call ClearScreen
    mov ecx, -1
    mov edi, 0xB8000
    sub edi, 2
    loopQSC:
    inc ecx
    cmp ecx, 25
    jge endQSC
    mov ebx, -1
        loopQSC2:
        inc ebx
        cmp ebx, 80
        jge loopQSC
        add edi, 2
        cmp ecx, 0
        je loopQSC2
        cmp ebx, 0
        je loopQSC2
        cmp ebx, 79
        je loopQSC2
        cmp ecx, 24
        je loopQSC2
        mov byte[edi], 0
        jmp loopQSC2
    endQSC:
    ret

times 1536-($-Snake) db 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NotePad:
call ClearScreen
mov si, notepadString
call printString
;mov si, ststring
;call printString
mov edi, 0xB80A0
cli
xor eax, eax

    checkAgain:
    in al, 0x64
    and al, 1
    jz checkAgain
    in al, 0x60
    cmp al, 0x80
    jae checkAgain
     cmp al, 0x0E;back space
        je bckspc
        cmp al, 0x1C;Enter
        je entr
        cmp al, 0x0F;tab
        je tab
        cmp al, 0x2A;shift
        je shift
        cmp al, 0x36
        je shift
        cmp al, 0x1D;control
        je ctrl
        cmp al, 0xE0
        je ctrl
        cmp al, 0x3A;Caps Lock
        je caps
        cmp al, 0x01;escape
        je escp
        cmp al, 0x48;up
        je upArr
        cmp al, 0x50;down
        je downArr
        cmp al, 0x4B;left
        je leftArr
        cmp al, 0x4D;right
        je rightArr
        xlat
        and esi, 1
        jnz big
        cmp al, 0x41
        jb big
        cmp al, 0x7B
        ja big
        ;cmp al, 0x5A
        ;jge tb
        ;jmp big
        ;tb:
        ;cmp al, 0x60
        ;jle big
        add al, 0x20
        big:
        mov ecx, edi
        mov dl, byte[edi]
        pushQueue:
            cmp byte[edi], 0
            je endQ
            mov bl, dl
            add edi, 2
            mov dl, byte[edi]
            mov byte[edi], bl
            jmp pushQueue
        endQ:
        mov edi, ecx
        mov byte[edi],al
        add edi,2
        mov bx, scanTable
        jmp checkAgain
        bckspc:
            sub edi, 2
            mov ecx, edi
            pullQueue:
            cmp byte[edi], 0x00
            je endQ2
            mov dl, byte[edi+2]
            mov byte[edi], dl
            add edi, 2
            jmp pullQueue
        endQ2:
            mov edi, ecx
            loopB2:
            cmp byte[edi], 0
            jne endB2
            sub edi, 2
            jmp loopB2
            endB2:
            add edi, 2
            jmp checkAgain
        entr:
            mov eax, edi
            sub eax, 0xB8000
            ;add edi, 160
            cdq
            mov ebx, 160;colomn length
            div ebx
            inc eax
            ;add edi, edx
            ;mov ecx, edx
            mul ebx;colomn length
            mov edi, 0xB8000
            add edi, eax
            ;mov edi, eax
 ;           loopff:
;                inc ecx
;                cmp ecx, 80
;                mov byte[edi], 0x0
;                add edi, 2
;                jmp loopff
            ;loopentr:
;                cmp byte[edi], 0
;                je endE
;                mov bl, byte[edi]
;                mov byte[esi], bl
;                add edi, 2
;                add esi, 2
;                jmp loopentr
;            endE:
            mov bx, scanTable
            ;mov byte[edi], ' '
            jmp checkAgain
        tab:
            mov eax, edi
            sub eax, 0xB8000
            mov ebx, 160
            cdq
            div ebx
            mov eax, edx
            mov ebx, 5
            cdq
            div ebx
            mov eax, edx
            mov ecx, 0
            loopy3:
            inc ecx
            cmp ecx, eax
            jg endy3
            mov byte[edi], ' '
            add edi, 2
            jmp loopy3
            endy3:
            jmp checkAgain
        shift:
           ; mov bx, scanTable2
            checkAgain2:
            IN al, 0x64
            and al, 1
            jz checkAgain2
            IN al, 0x60
            cmp al, 0xAA;break code of shift
            je temp
            cmp al, 0xB6
            je temp
            cmp al, 0x2A
            je temp
            cmp al, 0x36
            je temp
            cmp al, 0x80
            jae checkAgain2
            ;cmp al, 0x1C
            xlat
            and esi, 1
            jz big2
            add al, 0x20
            big2:
            mov ecx, edi
            mov dl, byte[edi]
            pushQueue2:
            cmp byte[edi], 0
            je endQ3
            mov bl, dl
            add edi, 2
            mov dl, byte[edi]
            mov byte[edi], bl
            jmp pushQueue2
            endQ3:
            mov edi, ecx
            ;mov bx, scanTable2
            mov byte[edi],al
            add edi,2
            jmp checkAgain2
            temp:
            mov bx, scanTable
            jmp checkAgain
        ctrl:
            jmp checkAgain
        caps:
            xor esi, 1
            jmp checkAgain
        escp:
        call ClearScreen
        jmp OS
        upArr:
            cmp edi, 160
            jl checkAgain
            sub edi, 160
            cmp byte[edi], 0
            jne checkAgain
            loopy:
            sub edi, 2
            cmp byte[edi], 0
            je loopy
            add edi, 2
            jmp checkAgain
        downArr:
            add edi, 160
            loopy2:
            sub edi, 2
            cmp byte[edi],0
            je loopy2
            add edi, 2
            jmp checkAgain
        leftArr:
            sub edi, 2
            loopy5:
            sub edi, 2
            cmp byte[edi], 0
            je loopy5
            jmp checkAgain
        rightArr:
            mov ebx, edi
            mov ecx, -1
            loopy4:
            inc ecx
            cmp ecx, 81
            jge teo
            cmp byte[edi], 0
            jne checkAgain
            add edi, 2
            jmp loopy4
            teo:
            mov edi, ebx
            jmp checkAgain 
times 1024-($-NotePad) db 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Calculator:
    cli
    call ClearScreen
    mov si, calculatorString
    call printString
    ;mov si, ststring
    ;call printString
    mov edi, 0xB80A0
    Cal:
    nop
    strt:
    mov ecx, -1
    mov bx, scanTable
    ;mov esi, 0
    check28:
        IN al, 0x64
        and al, 1
        jz check28
        IN al, 0x60
        cmp al,0x80
        jae check28
        cmp al, 0x01;escape key
        je QUIT_CALC
        cmp al, 0x1C;enter key
        je go1
        cmp al, 0x35;
        je slash
        cmp al, 0x37;
        je star
        cmp al, 0x4A;
        je minus
        cmp al, 0x4E;
        je plus
        
        xlat
        cmp al, 'E';
        je pow
        inc ecx
        mov byte[exp+ecx], al
        mov byte[edi], al
        add edi, 2
        jmp check28
        slash:
            inc ecx
            mov byte[exp+ecx], '/'
           mov byte[edi], '/'
            add edi, 2
            jmp check28
        star:
            inc ecx
            mov byte[exp+ecx], '*'
            mov byte[edi], '*'
            add edi, 2
            jmp check28
        plus:
            inc ecx
            mov byte[exp+ecx], '+'
            mov byte[edi], '+'
            add edi, 2
            jmp check28
        minus:
            inc ecx
            mov byte[exp+ecx], '-'
            mov byte[edi], '-'
            add edi, 2
            jmp check28
        pow:
            inc ecx
            mov byte[exp+ecx], '^'
            mov byte[edi], '^'
            add edi, 2
            jmp check28
    go1:
    add edi, 160
    xor eax, eax
    mov ecx,-1
    loop11S:
        inc ecx
        cmp ecx, 20
        jge end11S
        mov al, [exp+ecx]
        cmp al, 0
        je end11S
        jmp loop11S
    end11S:
    mov byte[p], 0
    mov dword[n], ecx
    mov ecx,-1
    loop21:
        inc ecx
        cmp ecx, [n]
        jge end21
        mov bl, byte[exp+ecx]

        mov esi, -1
        loop31:
            inc esi
            cmp esi, 10
            jge end31
            cmp bl, byte[nums+esi]
            jne loop31
            sub bl, 0x30
            cmp byte[p], 0
            jne nn
            mov eax, dword[num1]
            mul dword[ten]
            movzx ebx, bl
            add eax, ebx
            mov dword[num1], eax
            mov bl, [exp+ecx]
            jmp loop21
            nn:
            mov eax, dword[num2]
            mul dword[ten]
            movzx ebx, bl
            add eax, ebx
            mov dword[num2], eax
            jmp loop21
        end31:
        mov esi, -1
        loop41:
            cmp ecx, 0
            je loop21
            inc esi
            cmp esi, 5
            jge loop21
            cmp bl, [ops+esi]
            jne loop41
            mov al, byte[ops+esi]
            mov byte[op], al
            mov byte[p], 1
            jmp loop21
    end21:
    cli
    mov edi, 0xB8000
    add edi, 320
    cmp byte[exp], '-'
    jne c0
    neg dword[num1]
    c0:
    cmp byte[op], '+'
    jne c1
    mov eax, dword[num1]
    add eax, dword[num2]
    jmp cc
    c1:
    cmp byte[op], '-'
    jne c2
    mov eax, dword[num1]
    sub eax, dword[num2]
    jmp cc
    c2:
    cmp byte[op], '*'
    jne c3
    mov eax, dword[num1]
    mul dword[num2]
    jmp cc
    c3:
    cmp byte[op], '/'
    jne c4
    cmp dword[num2], 0
    je infi
    mov eax, dword[num1]
    cdq
    div dword[num2]
    jmp cc
    c4:
    cmp byte[op], '^'
    jne err
    mov ecx, -1
    mov ebx, dword[num1]
    mov eax, 1
    loopPow:
        inc ecx
        cmp ecx, dword[num2]
        jge cc
        mul ebx
        jmp loopPow 
    jmp cc
    err:
        nop
    cc:
        cmp eax, 0
        jl r5
        mov ebx, eax
        mov si, ans
        call printString
        mov eax, ebx
        cmp eax, 0
        jne r444
        mov byte[edi], '0'
        jmp end01
        cmp eax, 0
        jg r444
        r5:
        neg eax
        mov ebx, eax
        mov si, ans
        call printString
        mov eax, ebx
        mov byte[edi], '-'
        add edi, 2
        r444:
        mov ecx, -1
        loopresP:
            inc ecx
            cmp eax, 0
            je endresP
            cdq
            mov ebx, 10
            div ebx
            and edx, 0xf
            add edx, 0x30
            mov byte[result+ecx], dl
            jmp loopresP
         endresP:
        mov esi, ecx
        mov ecx, -1
        mov ebx, esi
        loop022:
            inc ecx
            dec ebx
            cmp ecx, esi
            jge end011
            mov al, [result+ebx]
            cmp al, 0
            je end011
            mov byte[edi], al
            add edi, 2
            jmp loop022
    end011:
    ll:
        in al, 0x64
        and al, 1
        jz ll
        in al, 0x60
        cmp al, 0x1C
        je strtt
        jmp ll
    strtt:
    call ClearScreen2
    mov dword[num1],0
    mov dword[num2],0
    mov ecx, -1
    loopwe:
    inc ecx
    cmp ecx, 20
    jge strt
    mov byte[exp+ecx], 0
    jmp loopwe
    jmp strt
    infi:
    mov si, ans
    call printString
    mov si, infinte
    call printString
    jmp end01
QUIT_CALC:
    call ClearScreen
    mov dword[num1],0
    mov dword[num2],0
    mov ecx, -1
    loopwe2:
    inc ecx
    cmp ecx, 20
    jge OS
    mov byte[exp+ecx], 0
    jmp loopwe2
    jmp OS

times 1024-($-Calculator) db 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Pong:
    call ClearScreen
    cli
    ;jmp $
    call setupP
    loopinfP:
    call gamePong
    cmp byte[GAmeOVer], 't'
    je QUIT_PONG
    jne loopinfP
    jmp QUIT_PONG
    ;logic
setupP:
    mov dword[pad1], 10
    mov dword[pad2], 10
    mov dword[padsize], 4
    mov dword[ballX], 40
    mov dword[ballY], 12
    mov dword[ballspeedX], 1
    mov dword[ballspeedY], 1
    mov dword[scoreP], 0
    mov dword[scoreP+4], 0
    mov word[direction], 'RU'
    mov byte[GAmeOVer], 'f'
    mov dword[MaxScoreP], 8
    mov dword[dP], 2
    mov dword[modeP], 1
    call ClearScreen
    mov si, welcome
    call printString
    jmp printscrnP
    lP1:
    in al, 0x64
    and al, 1
    jz lP1
    in al, 0x60
    cmp al, 0x1C
    jne tP1
    ret
    tP1:
    cmp al, 0x11;w
    jne LP2
    mov dword[modeP], 1
    jmp printscrnP
    LP2:
    cmp al, 0x1E;a
    jne LP3
    cmp dword[dP], 4
    jge printscrnP
    inc dword[dP]
    jmp printscrnP
    LP3:
    cmp al, 0x1F;s
    jne LP4
    mov dword[modeP], 0
    jmp printscrnP
    LP4:
    cmp al, 0x20;d
    jne endlP
    cmp dword[dP], 1
    jle printscrnP
    dec dword[dP]
    jmp printscrnP
    endlP:
    cmp al, 0x1C
    jne printscrnP
    ret
    printscrnP:
    mov edi, 0xB80A0
    mov si, md
    call printString
    cmp dword[modeP], 1
    jne mP1
    mov si, PvsC
    call printString
    jmp mP2
    mP1:
    mov si, PvsP
    call printString
    mP2:
    mov edi, 0xB8140
    mov si, difP
    call printString
    cmp dword[dP], 4
    jne dP1
    mov si, slow
    call printString
    jmp dP4
    dP1:
    cmp dword[dP], 3
    jne dP2
    mov si, medium
    call printString
    jmp dP4
    dP2:
    cmp dword[dP], 2
    jne dP3
    mov si, fast
    call printString
    jmp dP4
    dP3:
    mov si, Vfast
    call printString
    dP4:
    mov edi, 0xB80A0
    add edi, 320
    mov si, waiting
    call printString
    
    jmp lP1

logicP:
    
    cmp dword[ballX], 1
    jg p01
    mov eax, dword[ballY]
    cmp eax, dword[pad1]
    jl p11
    mov ecx, dword[pad1]
    add ecx, dword[padsize]
    cmp eax, ecx
    jg p11
    jmp py
    p11:
    inc dword[scoreP+4]
    py:
    mov byte[direction], 'R'
    p01:
    cmp dword[ballY], 0
    jg p2
    ;cmp byte[direction+4], 'U'
    ;jne p2
    mov byte[direction+4], 'D'
    p2:
    cmp dword[ballX], 78
    jl p3
    mov eax, dword[ballY]
    cmp eax, dword[pad2]
    jl p33
    mov ecx, dword[pad2]
    add ecx, dword[padsize]
    cmp eax, ecx
    jg p33
    jmp py2
    p33:
    inc dword[scoreP]
    py2:
    mov byte[direction], 'L'
    p3:
    cmp dword[ballY], 23
    jl p4
    ;cmp byte[direction+4], 'D'
    ;jne p4
    mov byte[direction+4], 'U'
    p4:
    mov eax, 1
    cmp byte[direction],'R'
    je p5
    mov eax, -1
    p5:
    mov ebx, dword[ballspeedX]
    mul ebx
    add dword[ballX], eax
    mov eax, 1
    cmp byte[direction+4],'D'
    je p6
    mov eax, -1
    p6:
    mov ebx, dword[ballspeedY]
    mul ebx
    add dword[ballY], eax
    ;moving the paddles
    ;mov eax, dword[MaxScoreP]
    cmp dword[scoreP], 5
    jl q1
    mov byte[GAmeOVer], 't'
    mov byte[winner], 1
    q1:
    cmp dword[scoreP+4], 5
    jl q2
    mov byte[GAmeOVer], 't'
    mov byte[winner], 2
    q2:
    nop
    cmp dword[modeP], 0
    je ply
    computer:
        cmp dword[ballY], 19
        jae p09
        mov eax, dword[ballY]
        mov dword[pad2], eax
        ret
        p09:
        mov dword[pad2], 19
    ply:
    ret
    ;draw
drawP:
    call ClearScreen
    mov ecx, -1
    mov ebx, -1
    mov eax, dword[padsize]
    loopp1:
        inc ecx
        cmp ecx, 24
        jge endp1
        mov ebx, -1
        loopp2:
            inc ebx
            cmp ebx, 80
            jge loopp1
            cmp ebx, dword[ballX]
            jne pp1
            cmp ecx, dword[ballY]
            jne pp1
            mov byte[edi], 'O'
            add edi, 2
            jmp loopp2
            pp1:
            mov eax, dword[padsize]
            cmp ebx, 0
            jne pp2
            cmp ecx, dword[pad1]
            jl pp2
            add eax, dword[pad1]
            cmp ecx, eax
            jg pp2
            mov byte[edi], ']'
            add edi, 2
            jmp loopp2
            pp2:
            mov eax, dword[padsize]
            cmp ebx, 79
            jne pp3

            cmp ecx, dword[pad2]
            jl pp3
            add eax, dword[pad2]
            cmp ecx, eax
            jg pp3
            mov byte[edi], '['
            add edi, 2
            jmp loopp2
            pp3:
            mov byte[edi], 0
            add edi, 2
            jmp loopp2
    endp1:
    mov ecx, -1
    loopscoreP:
    inc ecx
    cmp ecx, 37
    je endS
    mov byte[edi], '#'
    add edi, 2
    jmp loopscoreP
    endS:
    mov byte[edi], ' '
    add edi, 2
    mov eax, dword[scoreP]
    add al, '0'
    mov byte[edi], al
    add edi, 2
    mov byte[edi], ' '
    add edi, 2
    mov byte[edi], ' '
    add edi, 2
    mov eax, dword[scoreP+4]
    add al, '0'
    mov byte[edi], al
    add edi, 2
    mov byte[edi], ' '
    add edi, 2
    mov ecx, -1
    loopscoreP2:
    inc ecx
    cmp ecx, 37
    je endS2
    mov byte[edi], '#'
    add edi, 2
    jmp loopscoreP2
    endS2:
    ret
    ;input
inputP:
    CLI
        ;IN al, 0x64
        ;and al, 1
        ;jz inputP
        IN al, 0x60
        cmp al,0x80
        jae endinput
        cmp al, 0x01;escape key
        jne pi0
        mov byte[GAmeOVer], 't'
        pi0:
        cmp al, 0x1F;make code of w
        jne pi1
        mov eax, dword[pad1]
        add eax, dword[padsize]
        cmp eax, 23
        jae endinput
        inc dword[pad1]
        jmp endinput
        pi1:
        cmp al, 0x11;make code of s
        jne pi2
        cmp dword[pad1], 0
        jbe endinput
        dec dword[pad1]
        jmp endinput
        pi2:
        cmp al, 0x26;make code of o
        jne pi3
        mov eax, dword[pad2]
        add eax, dword[padsize]
        cmp eax, 23
        jae endinput
        inc dword[pad2]
        jmp endinput
        pi3:
        cmp al, 0x18;make code of l
        jne pi4
        cmp dword[pad2], 0
        jbe endinput
        dec dword[pad2]
        jmp endinput
        pi4:
        nop
        endinput:
        ret
    ;game1
gamePong:
        call inputP
        call logicP
        call drawP
        call sleepP
        ret
    ;sleep
sleepP:
    mov eax, 5000000
    mov ebx, dword[dP]
    inc ebx
    mul ebx
    mov ecx, eax
    xor eax, eax
    loopSleepP:
    inc eax
    cmp eax, ecx
    jl loopSleepP
    ret
QUIT_PONG:
        
        call ClearScreen
         ;mov edi, 0xB8000
         cmp dword[modeP], 1
         jne Q1
         cmp byte[winner], 0
         je Q1
         mov si, comwon
         call printString
         jmp QE
         Q1:
         mov si, player
         call printString
         mov al, byte[winner]
         add al, '0'
         mov byte[edi], al
         add edi, 2
         mov si, won
         call printString
         QE:
         mov edi, 0xB80A0
         mov si, waiting
         call printString
         lP3:
         in al, 0x64
         and al, 1
         jz lP3
         in al, 0x60
         cmp al, 0x1C
         je OS
         jmp lP3
times 1536-($-Pong) db 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Painter:
cli
                mov ax,0x13     ; graphical mode 320x200 pixles 256 colors
                int 0x10	       ; set video mode
                
    prep:
                 mov byte[drawMode],0
               mov di,word[X]
                mov si,word[Y]
               A:
                cmp di,319
                jg incy
                mov ah,0x0C	;change color for a single pixle
	       mov al,0x0f	; retain color
	       mov cx,di 	; x
	       mov dx,si ; y
	       int 0x10
                inc di
                jmp A
                incy:
                cmp si,199
                jg B
                inc si
                mov di,word[X]
                jmp A
      B:     
      ;call showPointer
                mov byte[penDrawMode], 0
                mov byte[drawMode], 0
                mov byte[leftButtonMouse] , 0   
                
                     
p1:             cli        
                call initializeCustomStack
                call initializeMouse
                
                mov byte[drawAvailability], 1
                
                call initializeColorSelectionArea    
                mov byte[drawAvailability],0
    check:
                ;call pollRead
                in al , 0x64
                test al , 0x1
                jz RashMode8
                in al, 0x64
                and al, 0x20
                jz check2
                jmp _continue
    check2:
                in al,0x60
                cmp al, 0x01
                je QUIT_PAINTER
                jmp check
                
                
   RashMode8:
   cmp byte[currentShape] , 2
   jnz check
   cmp byte [leftButtonMouse] , 0
   jz check
   delay:
   cmp dword[spryCounter]  , 100000
   jg delayFinish
   inc dword[spryCounter]
   jmp delay
   
   delayFinish:
   mov dword[spryCounter] , 0
   call drawShapeAndStore
   
   
   jmp check
    _continue:
                
                
                cmp byte[drawMode],0
                jnz notPen
                
                cmp byte[penDrawMode],0
                jnz normalMouseOperation
                
                call isMouseInsideColorSelectionArea
                cmp al,0
                je normalMouseOperation
                call restoreLastPixelColor
                cmp byte[leftButtonMouse],0x00
                jnz leftButtonPressedInsideColorSelectionArea
                cmp byte[rightButtonMouse],0x00
                jz NoButtonPressedInsideColorSelectionArea
                mov byte[buttoN], 'r'
                jmp tag1
    NoButtonPressedInsideColorSelectionArea:
                call update
                call storeLastPixelColor
                call showPointer
                jmp check
    leftButtonPressedInsideColorSelectionArea:
                mov byte[buttoN], 'l'
                tag1:
                mov cx,[blackX]
                mov bx,[colorSquareLength]
                mov dx,[blackY]
                mov ax,bx
                call isMouseInsideHorizontalRectangle
                cmp al,0
                jz cianSquareTest
                cmp byte[buttoN], 'r'
                je R1
                mov byte[currentMainColor],0x00
                call drawCurrentColorSquare
                jmp regularUpdate
                R1:
                mov byte[currentAuxilaryColor],0x00
                call drawCurrentAuxilaryColorSquare
                jmp regularUpdate2
    cianSquareTest:
                mov cx,[cianX]
                mov bx,[colorSquareLength]
                mov dx,[cianY]
                mov ax,bx
                call isMouseInsideHorizontalRectangle
                cmp al,0
                jz redSquareTest
                cmp byte[buttoN], 'r'
                je R2
                mov byte[currentMainColor],0x03
                call drawCurrentColorSquare
                jmp regularUpdate
                R2:
                mov byte[currentAuxilaryColor],0x03
                call drawCurrentAuxilaryColorSquare
                jmp regularUpdate2
                
    redSquareTest:
                mov cx,[redX]
                mov bx,[colorSquareLength]
                mov dx,[redY]
                mov ax,bx
                call isMouseInsideHorizontalRectangle
                cmp al,0
                jz blueSquareTest
                cmp byte[buttoN], 'r'
                je R3
                mov byte[currentMainColor],0x04
                call drawCurrentColorSquare
                jmp regularUpdate
                R3:
                mov byte[currentAuxilaryColor],0x04
                call drawCurrentAuxilaryColorSquare
                jmp regularUpdate2
                
    blueSquareTest:
                mov cx,[blueX]
                mov bx,[colorSquareLength]
                mov dx,[blueY]
                mov ax,bx
                call isMouseInsideHorizontalRectangle
                cmp al,0
                jz orangeSquareTest
                cmp byte[buttoN], 'r'
                je R4
                mov byte[currentMainColor],0x01
                call drawCurrentColorSquare
                jmp regularUpdate
                R4:
                mov byte[currentAuxilaryColor],0x01
                call drawCurrentAuxilaryColorSquare
                jmp regularUpdate2
    orangeSquareTest:
                mov cx,[orangeX]
                mov bx,[colorSquareLength]
                mov dx,[orangeY]
                mov ax,bx
                call isMouseInsideHorizontalRectangle
                cmp al,0
                jz greenSquareTest
                cmp byte[buttoN], 'r'
                je R5
                mov byte[currentMainColor],0x0f
                call drawCurrentColorSquare
                jmp regularUpdate
                R5:
                mov byte[currentAuxilaryColor],0x0f
                call drawCurrentAuxilaryColorSquare
                jmp regularUpdate2
                 
    greenSquareTest:
                mov cx,[greenX]
                mov bx,[colorSquareLength]
                mov dx,[greenY]
                mov ax,bx
                call isMouseInsideHorizontalRectangle
                cmp al,0
                jz lineTest
                cmp byte[buttoN], 'r'
                je R6
                mov byte[currentMainColor],0x0A
                call drawCurrentColorSquare
                jmp regularUpdate
                R6:
                mov byte[currentAuxilaryColor],0x0A
                call drawCurrentAuxilaryColorSquare
                jmp regularUpdate2
                
    lineTest:
                mov cx,[lineX]
                mov bx,[colorSquareLength]
                mov dx,[lineY]
                mov ax,bx
                call isMouseInsideHorizontalRectangle
                cmp al,0
                jz circleTest
                mov byte[drawAvailability],1
                mov word[currentShape],0x01
                call drawCurrentShapeSquare
                mov al,[currentColor]
                mov [temporaryColor],al
                mov al,[shapesColor]
                mov [currentColor],al
                call drawLineShapeC
                mov al,[temporaryColor]
                mov [currentColor],al
                mov byte[drawAvailability],0
                jmp regularUpdate
                
    circleTest:
                mov cx,[circleX]
                mov bx,[colorSquareLength]
                mov dx,[circleY]
                mov ax,bx
                call isMouseInsideHorizontalRectangle
                cmp al,0
                jz rectangleTest
                mov byte[drawAvailability],1
                mov word[currentShape],0x03
                call drawCurrentShapeSquare
                mov al,[currentColor]
                mov [temporaryColor],al
                mov al,[shapesColor]
                mov [currentColor],al
                call drawCircleShapeC
                mov al,[temporaryColor]
                mov [currentColor],al
                mov byte[drawAvailability],0
                jmp regularUpdate
                
    rectangleTest:
                mov cx,[rectangleX]
                mov bx,[colorSquareLength]
                mov dx,[rectangleY]
                mov ax,bx
                call isMouseInsideHorizontalRectangle
                cmp al,0
                jz penTest
                mov byte[drawAvailability],1
                mov word[currentShape],0x02
                call drawCurrentShapeSquare
                mov al,[currentColor]
                mov [temporaryColor],al
                mov al,[shapesColor]
                mov [currentColor],al
                call drawRectangleShapeC
                mov al,[temporaryColor]
                mov [currentColor],al
                mov byte[drawAvailability],0
                jmp regularUpdate
                
    penTest:
                mov cx,[penX]
                mov bx,[colorSquareLength]
                mov dx,[penY]
                mov ax,bx
                call isMouseInsideHorizontalRectangle
                cmp al,0
                jz regularUpdate
                mov byte[drawAvailability],1
                mov word[currentShape],0x00
                call drawCurrentShapeSquare
                mov al,[currentColor]
                mov [temporaryColor],al
                mov al,[shapesColor]
                mov [currentColor],al
                call drawPenShapeC
                mov al,[temporaryColor]
                mov [currentColor],al
                mov byte[drawAvailability],0
                jmp regularUpdate
                  
    normalMouseOperation:
                cmp byte[currentShape],0
                jnz notPen
                
                cmp byte[leftButtonMouse],0x00
	        jne leftButtonPressed
                cmp byte[rightButtonMouse],0x00
                jne rightButtonPressed
                cmp byte[penDrawMode],0
                jz skip123
                call oldRestoreLastPixelColor
                call update
                call storeLastPixelColor
                ;mov al,[currentColor]
                ;mov [lastPixelColor],al
                call showPointer
                
                mov byte[penDrawMode],0
                jmp check
    skip123:
                call restoreLastPixelColor
    common123:
                call update
                call storeLastPixelColor
                call showPointer
                
                mov byte[penDrawMode],0
                jmp check
                
    leftButtonPressed1:
                
                call restoreLastPixelColor
                call update
                call storeLastPixelColor
                call storeInitialFilledPen
                call oldShowPointer
                mov byte[penDrawMode],1
                jmp check
    leftButtonPressed:
                mov al, byte[currentMainColor]
                mov byte[currentColor], al
               cmp byte[penDrawMode],0
               jz leftButtonPressed1
               
               call update
               call storeLastPixelColor
               
               call drawFilledPen               
               call storeInitialFilledPen
               jmp check
     rightButtonPressed1:
                
                call oldRestoreLastPixelColor
                call update
                call storeLastPixelColor
                call storeInitialFilledPen
                call oldShowPointer
                mov byte[penDrawMode],1
                jmp check
    rightButtonPressed:
                mov al, byte[currentAuxilaryColor]
                mov byte[currentColor], al
               cmp byte[penDrawMode],0
               jz rightButtonPressed1
               call update
               call storeLastPixelColor
               
               call drawFilledPen               
               call storeInitialFilledPen
               jmp check
               
               
    notPen:            ; you are outside color selection area with a shape other than pen
                cmp byte[leftButtonMouse],0x00
	       jne leftButtonPressedN
            cmp byte[rightButtonMouse],0x00
	       jne rightButtonPressedN
            
                cmp byte[drawMode],0
                jz notInDrawMode
                
                ;call drawStoredShape
                call update
                call isMouseInsideColorSelectionArea
                cmp al,0
                jne finishDrawingInsideColorSelectionArea
                call storeLastPixelColor
                ;mov al,[currentColor]
;                mov [lastPixelColor],al
                jmp finishDrawing
    finishDrawingInsideColorSelectionArea:
                call storeLastPixelColor
    finishDrawing:
                ;call drawShapeAndStore
                jmp doneOtherShapes
    notInDrawMode:
                call restoreLastPixelColor
                call update
                call storeLastPixelColor
                call showPointer
                jmp check
    leftButtonPressedN:
                mov al, byte[currentMainColor]
                mov byte[currentColor], al
                cmp byte[drawMode],0
                jz notInDrawModeAndPressed
                call drawStoredShape
                call update
                call drawShapeAndStore
                jmp check
                
                
    rightButtonPressedN:
                mov al, byte[currentAuxilaryColor]
                mov byte[currentColor], al
                cmp byte[drawMode],0
                jz notInDrawModeAndPressed
                call drawStoredShape
                call update
                call drawShapeAndStore
                jmp check
    notInDrawModeAndPressed:
                cmp byte[currentShape],3
                jne notCircle
                call restoreLastPixelColor
                jmp isCircle
notCircle:
                call oldRestoreLastPixelColor
isCircle:
                call storeInitialShapeValues
                call update
                call drawShapeAndStore
    doneOtherShapes:
                xor byte[drawMode],1
                
                jmp check
regularUpdate:
                mov al, byte[currentMainColor]
                mov byte[currentColor], al
                call update
                call storeLastPixelColor
                call showPointer
                jmp check
                hlt

regularUpdate2:
                mov al, byte[currentAuxilaryColor]
                mov byte[currentColor], al
                call update
                call storeLastPixelColor
                call showPointer
                jmp check
                hlt
 
update:
                call setMouseStatus
                call setXMouse
                call setYMouse
                ;call setZMouse
                ret
                
drawShapeAndStore:
                cmp byte[currentShape],1
                jne circleT1
                call drawLineAndStore
                ret
    circleT1:
                cmp byte[currentShape],3
                jne rectangleT1
                call drawCircleAndStore
                ret
    rectangleT1:
                call drawRectangleAndStore
    doneT1:
                ret
                
drawStoredShape:
                cmp byte[currentShape],1
                jne circleT2
                call drawStoredLine
                ret
    circleT2:
                cmp byte[currentShape],3
                jne rectangleT2
                call drawStoredCircle
                ret
    rectangleT2:
                call drawStoredRectangle
    doneT2:
                ret
                
                
storeInitialShapeValues:
                cmp byte[currentShape],1
                jne circleT3
                call storeInitialLineValues
                ret
    circleT3:
                cmp byte[currentShape],3
                jne rectangleT3
                call storeInitialCircleValues
                ret
    rectangleT3:
                call storeInitialRectangleValues
    doneT3:
                ret

drawCircleAndStore:
                call calRadius	
                call circleAndStore
                ret
                
storeInitialCircleValues:
                mov ax , [xMouse]
                mov [xc] , ax
                mov ax , [yMouse]
                mov [yc], ax
                ret
                  
drawStoredCircle:
                call calRadius
                call circleAndRestore
                ret
                
 storeInitialFilledPen:
                mov ax,[xMouse]
                mov [xFilledPen],ax
                
                mov ax,[yMouse]
                mov [yFilledPen],ax
                
                ret
                
drawFilledPen:
                mov ax,[xFilledPen]
                mov [xl],ax
                
                mov ax,[yFilledPen]
                mov [yl],ax
                
                call drawLineAndStore
                ret
                               
finish: 
        ret
drawLineAndStore:
        mov ax,[xl]
        mov [xdot1],ax
        mov ax,[yl]
        mov [ydot1],ax
        mov ax,[xMouse]
        mov [xdot2],ax
        mov ax,[yMouse]
        mov [ydot2],ax
        
        mov esi,restoreCounter
        mov  cx, [xdot1]	; x
        mov  dx, [ydot1]	; y
        call draw
        
        cmp cx,[xdot2]
        je verticalLine
        jl ordered
        xchg cx,[xdot2]
        xchg dx,[ydot2]
        mov [xdot1],cx
        mov [ydot1],dx
    ordered:
        finit
     loop1:
        mov [yold],dx
        inc cx
        cmp cx,[xdot2]
        jg finish
        fild dword[ydot2]
        fild dword[ydot1]
        fsubp
        mov [xnew],cx
        fild dword[xnew]
        fild dword[xdot1]
        fsubp
        fmulp
        fild dword[xdot2]
        fild dword[xdot1]
        fsubp
        fdivp
        fiadd dword[ydot1]
        fistp dword[ynew]
        mov dx,[ynew]
        cmp [yold],dx
        jle yOrdered
        
    Loop3:
        cmp dx,word[yold]
        jg exitLoop2
        call draw
        inc dx
        jmp Loop3
     yOrdered:  
        mov dx,[yold]
    Loop2:
        cmp dx,word[ynew]
        jg exitLoop2
        call draw
        inc dx
        jmp Loop2    
     exitLoop2:
        mov dx,[ynew]
        jmp loop1 
     verticalLine:
        cmp dx,[ydot2]
        jle yOrderedInVerticalLine
        xchg dx,[ydot2]
    yOrderedInVerticalLine:
        inc dx
        cmp dx,[ydot2]
        jg finish
        call draw
        jmp  yOrderedInVerticalLine                     
                     
       
drawStoredLine:
        mov ax,[xl]
        mov [xdot1],ax
        mov ax,[yl]
        mov [ydot1],ax
        mov ax,[xMouse]
        mov [xdot2],ax
        mov ax,[yMouse]
        mov [ydot2],ax
        
        mov esi,restoreCounter
        mov  cx, [xdot1]	; x
        mov  dx, [ydot1]	; y
        call draw1
        
        cmp cx,[xdot2]
        je verticalLine1
        jl ordered1
        xchg cx,[xdot2]
        xchg dx,[ydot2]
        mov [xdot1],cx
        mov [ydot1],dx
    ordered1:
        finit
     loop11:
        mov [yold],dx
        inc cx
        cmp cx,[xdot2]
        jg finish
        fild dword[ydot2]
        fild dword[ydot1]
        fsubp
        mov [xnew],cx
        fild dword[xnew]
        fild dword[xdot1]
        fsubp
        fmulp
        fild dword[xdot2]
        fild dword[xdot1]
        fsubp
        fdivp
        fiadd dword[ydot1]
        fistp dword[ynew]
        mov dx,[ynew]
        cmp [yold],dx
        jle yOrdered1
        
    Loop31:
        cmp dx,word[yold]
        jg exitLoop21
        call draw1
        inc dx
        jmp Loop31
     yOrdered1:  
        mov dx,[yold]
    Loop21:
        cmp dx,word[ynew]
        jg exitLoop21
        call draw1
        inc dx
        jmp Loop21    
     exitLoop21:
        mov dx,[ynew]
        jmp loop11 
     verticalLine1:
        cmp dx,[ydot2]
        jle yOrderedInVerticalLine1
        xchg dx,[ydot2]
    yOrderedInVerticalLine1:
        inc dx
        cmp dx,[ydot2]
        jg finish
        call draw1
        jmp  yOrderedInVerticalLine1  
 
                
storeInitialLineValues:
                mov ax,[xMouse]
                mov [xl],ax
                mov ax,[yMouse]
                mov [yl],ax
                ret
                
drawRectangleAndStore:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;cmp word[spryCounter],10000
;jl skipSprayTest
;mov word[spryCounter],0
;cmp byte[leftButtonMouse],0
;je skipSprayTest
;jmp RashMode1
;
;skipSprayTest:
;inc word[spryCounter]
;mov word[spryCounter],0
;
;
;	
;cmp byte[leftButtonMouse],0x00
;
;JNE RashMode
;
;mov ah,0x0C	
;mov al,[lastPixelColor]	; retain color
;mov cx,[xMouse] 	; x
;mov dx,[yMouse] 	; y
;int 0x10
;jmp Next
;
;RashMode:
;
mov ax , [xMouse]
mov [x] , ax

mov ax , [yMouse]
mov [y] , ax

mov cx, [xMouse]
mov dx, [yMouse]
call randomDraw
;call draw
;call update
;jmp check
ret
;RashMode1:
;
;mov ax , [xMouse]
;mov [x] , ax
;
;mov ax , [yMouse]
;mov [y] , ax
;
;call randomDraw
;
;jmp skipSprayTest
;
;Next:
;call update
;mov ah,0x0d
;mov cx,[xMouse]         ; x
;mov dx,[yMouse]         ; y
;int 0x10
;mov [lastPixelColor],al 
;                
;mov al,[currentColor]
;mov  ah,0xC 	; change pixle color
;mov  cx, [xMouse]	; x
;mov  dx, [yMouse]	; y
;int  0x10 	; call BIOS service
;    
;jmp check
;
;

;ret






;=====Functions====;

;Fun1

;Fun5
randomDraw:
mov bx , 0
l12:
cmp bx , 5
JGE done
mov [counter],bx

guessX:
call binaryRandomGenerator
cmp dx ,1
JE NegativeX

PositiveX:
mov ax , [maximumRadius]
mov [r] , ax
call randomGeneratorModified
mov [xGuess] , dx
add dx , [x]
mov [xr] , dx
call calculateMaximumRadiusY
jmp guessYy

NegativeX:
mov ax , [maximumRadius]
mov [r] , ax
call randomGeneratorModified
mov [xGuess] , dx
neg dx
add dx , [x]
mov [xr] , dx
call calculateMaximumRadiusY
;jmp guessYy
guessYy:
;mov ax , [maximumRadius]
;mov [r] , ax
call binaryRandomGenerator
cmp dx , 1
JE NegativeY

PositiveY:

call randomGeneratorModified

add dx , [y]
mov [yr] , dx
jmp done12

NegativeY:
;mov ax , [maximumRadius]
;mov [r] , ax

call randomGeneratorModified

neg dx
add dx ,[y]
mov [yr] ,dx

done12:
;ret
mov ah, 0x0c
mov al, [currentColor]
mov cx, [xr]
mov dx, [yr]
call draw;Protected
;call setMouseStatus

mov bx ,[counter]
inc bx
jmp l12
done:
ret




randomGeneratorModified:
rdtsc
mov ebx ,[r]
xor edx ,edx
div ebx
;==Rsult must be In dl ==;
ret

binaryRandomGenerator:
rdtsc
mov ebx ,2
xor edx , edx
div ebx
;==Rsult must be In dl ==;
ret

calculateMaximumRadiusY:
fild dword[maximumRadius]
fmul st0

fild dword[xGuess]
fmul st0

fsubp
fsqrt
fistp dword[r]

ret

                
                
                
                
                
                
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                
                
                
                ret
                
drawStoredRectangle:
                ret
                
storeInitialRectangleValues:
                ret
                
                
                
                
                
         
                                    
    calRadius:                
        mov ax , [xc]
        movsx eax , ax
        mov [xcd] , eax
        mov ax , [yc]
        movsx eax , ax
        mov [ycd] , eax
        	
        mov ax , [yMouse]
        movsx eax , ax
        mov [ymd] , eax	
        
        
        mov ax, [xMouse]
        movsx eax , ax
        mov [xmd] , eax	
        
        finit
        fild dword[xcd]
        fisub dword[xmd]
        fmul st0
        fild dword[ycd]
        fisub dword[ymd]
        fmul st0
        faddp
        fsqrt
        fistp dword[rd]
        mov eax , [rd]
        mov [r] , ax
                
        ret
        
        
        
         circleAndStore:
        mov esi , restoreCounter
        mov ax , [r]
        cmp ax , 0
        JE Send
        mov [x] , ax 
        mov ax , [x]
        add ax , [xc]
        
        mov [xn], ax
        mov ax , 0 
        mov [y], ax
        mov ax , [y]
        add ax , [yc]
        mov [yn],ax
        ;print it
        
        mov cx, [xn]
        mov dx, [yn]
        call draw
        
        
       
        mov ax , [xn]
        sub ax, [r]
        mov [xn] , ax 
        mov ax, [yn]
        add ax , [r]
        mov [yn], ax 
        ;print it
        mov cx, [xn]
        mov dx, [yn]
        call draw
        
        mov ax , [x]
        neg ax
        add ax , [xc]
        mov [xn], ax
        mov ax , [y]
        add ax , [yc]
        mov [yn],ax
        ;print
        mov cx, [xn]
        mov dx, [yn]
        call draw
        
        mov ax , [xn]
        add ax , [r]
        mov [xn] ,ax
        mov ax, [yn]
        sub ax , [r]
        mov [yn] ,ax
        ;print
        mov cx, [xn]
        mov dx, [yn]
        call draw  
        
        ;Drawing The Circle
        mov ax,  1
        mov [p] , ax
        mov ax , [p]
        sub ax , [r]
        mov [p], ax
        
        Sl1:
        mov ax, [x]
        cmp ax, [y]
        JLE Sdone1
        mov ax , [y]
        inc ax
        mov [y] , ax
        
        mov ax, [p]
        cmp ax , 0
        JG Sl2
        mov dx , [y]
        shl dx ,1
        add ax , dx
        add ax, 1
        mov [p] , ax
        jmp Sdone2
        Sl2:
        mov dx , [x]
        dec dx
        mov [x] ,dx
        sub dx , [y]
        neg dx
        shl dx , 1
        add ax , dx
        add ax , 1
        mov [p], ax
        Sdone2:
        mov ax , [x]
        cmp ax ,  [y]
        JL Sdone1
        
        mov ax , [x]
        add ax , [xc]
        mov [xn], ax
        mov ax , [y]
        add ax , [yc]
        mov [yn],ax
        ;print it
        mov cx, [xn]
        mov dx, [yn]
        call draw
        
        mov ax , [x]
        neg ax
        add ax , [xc]
        mov [xn] , ax
        ;print it
        mov cx, [xn]
        mov dx, [yn]
        call draw
        
        
        mov ax , [y]
        neg ax
        add ax , [yc]
        mov [yn] , ax
        
        ;print
        mov cx, [xn]
        mov dx, [yn]
        call draw
        
        mov ax , [x]
        add ax , [xc]
        mov [xn] , ax
        mov ax , [y]
        neg ax
        add ax , [yc]
        mov [yn] , ax
        ;print
        mov cx, [xn]
        mov dx, [yn]
        call draw
        
        mov ax, [x]
        cmp ax, [y]
        JE Sdone1
        
        mov ax , [y]
        add ax , [xc]
        mov [xn], ax
        mov ax , [x]
        add ax , [yc]
        mov [yn],ax
        ;print it
        mov cx, [xn]
        mov dx, [yn]
        call draw
        
        mov ax , [y]
        neg ax
        add ax , [xc]
        mov [xn], ax
        ;print
        mov cx, [xn]
        mov dx, [yn]
        call draw
        
        mov ax , [x]
        neg ax
        add ax , [yc]
        mov [yn], ax
        ;print
        mov cx, [xn]
        mov dx, [yn]
        call draw
        
        mov ax , [y]
        add ax , [xc]
        mov [xn] , ax
        mov ax , [x]
        neg ax
        add ax , [yc]
        mov [yn] , ax
        ;print
        mov cx, [xn]
        mov dx, [yn]
        call draw
        
        jmp Sl1
        Sdone1:
        jmp Send1
        Send:
        mov al , 0x00
        mov ah , 0x0c
        mov cx , [xc]
        mov dx , [yc]
        call draw
        Send1:
        
        ret
        
        
        
        circleAndRestore:
        mov esi , restoreCounter
        mov ax , [r]
        cmp ax , 0
        JE end
        mov [x] , ax 
        mov ax , [x]
        add ax , [xc]
        
        mov [xn], ax
        mov ax , 0 
        mov [y], ax
        mov ax , [y]
        add ax , [yc]
        mov [yn],ax
        ;print it
        
        mov cx, [xn]
        mov dx, [yn]
        call draw1
        
       
        mov ax , [xn]
        sub ax, [r]
        mov [xn] , ax 
        mov ax, [yn]
        add ax , [r]
        mov [yn], ax 
        ;print it
        mov cx, [xn]
        mov dx, [yn]
        call draw1
        
        mov ax , [x]
        neg ax
        add ax , [xc]
        mov [xn], ax
        mov ax , [y]
        add ax , [yc]
        mov [yn],ax
        ;print
        mov cx, [xn]
        mov dx, [yn]
        call draw1
        
        mov ax , [xn]
        add ax , [r]
        mov [xn] ,ax
        mov ax, [yn]
        sub ax , [r]
        mov [yn] ,ax
        ;print
        mov cx, [xn]
        mov dx, [yn]
        call draw1 
        
        ;Drawing The Circle
        mov ax,  1
        mov [p] , ax
        mov ax , [p]
        sub ax , [r]
        mov [p], ax
        
        L01:
        mov ax, [x]
        cmp ax, [y]
        JLE done1
        mov ax , [y]
        inc ax
        mov [y] , ax
        
        mov ax, [p]
        cmp ax , 0
        JG l2
        mov dx , [y]
        shl dx ,1
        add ax , dx
        add ax, 1
        mov [p] , ax
        jmp done2
        l2:
        mov dx , [x]
        dec dx
        mov [x] ,dx
        sub dx , [y]
        neg dx
        shl dx , 1
        add ax , dx
        add ax , 1
        mov [p], ax
        done2:
        mov ax , [x]
        cmp ax ,  [y]
        JL done1
        
        mov ax , [x]
        add ax , [xc]
        mov [xn], ax
        mov ax , [y]
        add ax , [yc]
        mov [yn],ax
        ;print it
        mov cx, [xn]
        mov dx, [yn]
        call draw1
        
        mov ax , [x]
        neg ax
        add ax , [xc]
        mov [xn] , ax
        ;print it
        mov cx, [xn]
        mov dx, [yn]
        call draw1
        
        
        mov ax , [y]
        neg ax
        add ax , [yc]
        mov [yn] , ax
        
        ;print
        mov cx, [xn]
        mov dx, [yn]
        call draw1
        
        mov ax , [x]
        add ax , [xc]
        mov [xn] , ax
        mov ax , [y]
        neg ax
        add ax , [yc]
        mov [yn] , ax
        ;print
        mov cx, [xn]
        mov dx, [yn]
        call draw1
        
        mov ax, [x]
        cmp ax, [y]
        JE done1
        
        mov ax , [y]
        add ax , [xc]
        mov [xn], ax
        mov ax , [x]
        add ax , [yc]
        mov [yn],ax
        ;print it
        mov cx, [xn]
        mov dx, [yn]
        call draw1
        
        mov ax , [y]
        neg ax
        add ax , [xc]
        mov [xn], ax
        ;print
        mov cx, [xn]
        mov dx, [yn]
        call draw1
        
        mov ax , [x]
        neg ax
        add ax , [yc]
        mov [yn], ax
        ;print
        mov cx, [xn]
        mov dx, [yn]
        call draw1
        
        mov ax , [y]
        add ax , [xc]
        mov [xn] , ax
        mov ax , [x]
        neg ax
        add ax , [yc]
        mov [yn] , ax
        ;print
        mov cx, [xn]
        mov dx, [yn]
        call draw1
        
        jmp L01
        done1:
        jmp end1
        end:
        mov al , 0x00
        mov ah , 0x0c
        mov cx , [xc]
        mov dx , [yc]
        int 10h
        end1:
        
        ret
        
draw:
    cmp cx, 0
    jl Sdont
    cmp cx, 319
    jg Sdont
    cmp dx, 0
    jl Sdont
    cmp dx, 199
    jg Sdont 
    cmp byte[drawAvailability],0
    jnz Scontinue
    cmp cx,[leftmostPixel]
    jl Scontinue
    cmp dx,[lowestPixel]
    jg Scontinue
    jmp Sdont
Scontinue:
    mov ah , 0xd
    int 10h
    mov [esi] , al
    inc esi
    mov al ,[currentColor]
    mov ah , 0xc
    int 10h
    ret
    Sdont:
    
    ret
    
    
    
        draw1:
    cmp cx, 0
    jl dont
    cmp cx, 319
    jg dont
    cmp dx, 0
    jl dont
    cmp dx, 199
    jg dont 
    cmp byte[drawAvailability],0
    jnz continue
    cmp cx,[leftmostPixel]
    jl continue
    cmp dx,[lowestPixel]
    jg continue
    jmp dont
continue:
    mov al ,[esi]
    inc esi
    mov ah , 0xc
    int 10h
    ret
    dont:
    ret
    
    
initializeCustomStack:
                mov dword[stackPointer],stackBase
                mov eax,[stackLength]
                add dword[stackPointer],eax
                ret

 drawCircleShape:
mov ax  , [colorSquareLength]
mov bx , 2
xor dx ,  dx
div bx
;===Calculate Xc ===;
mov bx , [circleX]
add bx, ax
mov [xc] , bx

;===Calculate Yc===;
 mov bx , [circleY]
 add bx , ax
 mov [yc] , bx 

;===Calculate R ===;
sub ax ,  2
mov [r] , ax

call circleAndStore

ret

 drawCircleShapeC:
mov ax  , [colorSquareLength]
mov bx , 2
xor dx ,  dx
div bx
;===Calculate Xc ===;
mov bx , [currentShapeX]
add bx, ax
mov [xc] , bx

;===Calculate Yc===;
 mov bx , [currentShapeY]
 add bx , ax
 mov [yc] , bx 

;===Calculate R ===;
sub ax ,  2
mov [r] , ax

call circleAndStore

ret


drawRectangleShape:
        push word[xMouse]
        push word[yMouse]
        mov cx,[rectangleX]
        mov dx,[rectangleY]
        add dx, 12
        add cx, 4
        sub dx, 8
        call draw
        add dx, 8
        mov [xl], cx
        mov [yl], dx
       
        mov [xMouse], cx
        add word[xMouse], 6
        mov [yMouse], dx
        call drawLineAndStore
        mov cx, [xMouse]
        mov [xl], cx
        mov cx, [yMouse]
        sub cx, 8
        mov [yl], cx
        call drawLineAndStore
        
        ;dec word[xl]
        mov cx, [yl]
        mov [yMouse], cx
        mov cx, [xl]
        sub cx, 6
        mov [xMouse], cx
        call drawLineAndStore
         
        mov cx, [xMouse]
        mov [xl], cx
        mov cx, [yMouse]
        add cx, 8
        mov [yl], cx
        call drawLineAndStore
        
        dec word[yMouse]
        
        mov cx, [xMouse]
        mov dx, [yMouse]
        add cx, 3
        call draw
        
        sub dx, 1
        call draw
        
        add cx, 1
        call draw
        
        
        pop word[yMouse]
        pop word[xMouse]
        
        ret
drawLineShape:
           mov esi,restoreCounter
           
            mov ax,[xMouse]
            sub dword[stackPointer],2
            mov ebx,[stackPointer]
            mov [ebx],ax
            
            mov ax,[yMouse]
            sub dword[stackPointer],2
            mov ebx,[stackPointer]
            mov [ebx],ax
            
             mov ax,[lineX]
            add ax,2
            mov [xl],ax
            
            add ax,[colorSquareLength]
            sub ax,4
            mov [xMouse],ax
            
            mov ax,[lineY]
            add ax,2
            mov [yl],ax
            
            add ax,[colorSquareLength]
            sub ax,4
            mov [yMouse],ax
            
            call drawLineAndStore
            
            mov ebx,[stackPointer]
            mov ax,[ebx]
            add dword[stackPointer],2
            mov [yMouse],ax
            
            mov ebx,[stackPointer]
            mov ax,[ebx]
            add dword[stackPointer],2
            mov [xMouse],ax
            
            ret
            
drawPenShape:
            mov esi,restoreCounter
           
            mov ax,[xMouse]
            sub dword[stackPointer],2
            mov ebx,[stackPointer]
            mov [ebx],ax
            
            mov ax,[yMouse]
            sub dword[stackPointer],2
            mov ebx,[stackPointer]
            mov [ebx],ax
            
             mov ax,[penX]
            add ax,6
            mov [xl],ax
            
            add ax,[colorSquareLength]
            sub ax,7
            mov [xMouse],ax
            
            mov ax,[penY]
            add ax,4
            mov [yl],ax
            
            add ax,[colorSquareLength]
            sub ax,7
            mov [yMouse],ax
            
            call drawLineAndStore
            
            
            
            mov ax,[penX]
            add ax,4
            mov [xl],ax
            
            add ax,[colorSquareLength]
            sub ax,7
            mov [xMouse],ax
            
            mov ax,[penY]
            add ax,7
            mov [yl],ax
            
            add ax,[colorSquareLength]
            sub ax,8
            mov [yMouse],ax
            
            call drawLineAndStore
            
            
            mov ax,[penX]
            add ax,4
            mov [xl],ax
            
            add ax,2
            mov [xMouse],ax
            
            mov ax,[penY]
            add ax,6
            mov [yl],ax
            
            sub ax,2
            mov [yMouse],ax
            
            call drawLineAndStore
            
            mov ax,[penX]
            add ax,[colorSquareLength]
            
            sub ax,1
            mov [xl],ax
            
            sub ax,2
            mov [xMouse],ax
            
            mov ax,[penY]
            add ax,[colorSquareLength]
            sub ax,3
            mov [yl],ax
            
            add ax,2
            mov [yMouse],ax
            
            call drawLineAndStore
            
             mov ax,[penX]
            add ax,4
            mov [xl],ax
            
            sub ax,3
            mov [xMouse],ax
            
            mov ax,[penY]
            add ax,6
            mov [yl],ax
            
            sub ax,5
            mov [yMouse],ax
            
            call drawLineAndStore
            
             mov ax,[penX]
            add ax,6
            mov [xl],ax
            
            sub ax,5
            mov [xMouse],ax
            
            mov ax,[penY]
            add ax,4
            mov [yl],ax
            
            sub ax,3
            mov [yMouse],ax
            
            call drawLineAndStore
            
            mov ebx,[stackPointer]
            mov ax,[ebx]
            add dword[stackPointer],2
            mov [yMouse],ax
            
            mov ebx,[stackPointer]
            mov ax,[ebx]
            add dword[stackPointer],2
            mov [xMouse],ax
            
            ret
drawRectangleShapeC:
                push word[xMouse]
        push word[yMouse]
        mov cx,[currentShapeX]
        mov dx,[currentShapeY]
        add dx, 12
        add cx, 4
        sub dx, 8
        call draw
        add dx, 8
        mov [xl], cx
        mov [yl], dx
       
        mov [xMouse], cx
        add word[xMouse], 6
        mov [yMouse], dx
        call drawLineAndStore
        mov cx, [xMouse]
        mov [xl], cx
        mov cx, [yMouse]
        sub cx, 8
        mov [yl], cx
        call drawLineAndStore
        
        ;dec word[xl]
        mov cx, [yl]
        mov [yMouse], cx
        mov cx, [xl]
        sub cx, 6
        mov [xMouse], cx
        call drawLineAndStore
         
        mov cx, [xMouse]
        mov [xl], cx
        mov cx, [yMouse]
        add cx, 8
        mov [yl], cx
        call drawLineAndStore
        
        dec word[yMouse]
        
        mov cx, [xMouse]
        mov dx, [yMouse]
        add cx, 3
        call draw
        
        sub dx, 1
        call draw
        
        add cx, 1
        call draw
        
        
        pop word[yMouse]
        pop word[xMouse]
        
        ret
drawLineShapeC:
            mov esi,restoreCounter
           
            mov ax,[xMouse]
            sub dword[stackPointer],2
            mov ebx,[stackPointer]
            mov [ebx],ax
            
            mov ax,[yMouse]
            sub dword[stackPointer],2
            mov ebx,[stackPointer]
            mov [ebx],ax
            
             mov ax,[currentShapeX]
            add ax,2
            mov [xl],ax
            
            add ax,[colorSquareLength]
            sub ax,4
            mov [xMouse],ax
            
            mov ax,[currentShapeY]
            add ax,2
            mov [yl],ax
            
            add ax,[colorSquareLength]
            sub ax,4
            mov [yMouse],ax
            
            call drawLineAndStore
            
            mov ebx,[stackPointer]
            mov ax,[ebx]
            add dword[stackPointer],2
            mov [yMouse],ax
            
            mov ebx,[stackPointer]
            mov ax,[ebx]
            add dword[stackPointer],2
            mov [xMouse],ax
            
            ret
            
            
drawPenShapeC:
            
            mov esi,restoreCounter
           
            mov ax,[xMouse]
            sub dword[stackPointer],2
            mov ebx,[stackPointer]
            mov [ebx],ax
            
            mov ax,[yMouse]
            sub dword[stackPointer],2
            mov ebx,[stackPointer]
            mov [ebx],ax
            
             mov ax,[currentShapeX]
            add ax,6
            mov [xl],ax
            
            add ax,[colorSquareLength]
            sub ax,7
            mov [xMouse],ax
            
            mov ax,[currentShapeY]
            add ax,4
            mov [yl],ax
            
            add ax,[colorSquareLength]
            sub ax,7
            mov [yMouse],ax
            
            call drawLineAndStore
            
            
            
            mov ax,[currentShapeX]
            add ax,4
            mov [xl],ax
            
            add ax,[colorSquareLength]
            sub ax,7
            mov [xMouse],ax
            
            mov ax,[currentShapeY]
            add ax,7
            mov [yl],ax
            
            add ax,[colorSquareLength]
            sub ax,8
            mov [yMouse],ax
            
            call drawLineAndStore
            
            
            mov ax,[currentShapeX]
            add ax,4
            mov [xl],ax
            
            add ax,2
            mov [xMouse],ax
            
            mov ax,[currentShapeY]
            add ax,6
            mov [yl],ax
            
            sub ax,2
            mov [yMouse],ax
            
            call drawLineAndStore
            
            mov ax,[currentShapeX]
            add ax,[colorSquareLength]
            
            sub ax,1
            mov [xl],ax
            
            sub ax,2
            mov [xMouse],ax
            
            mov ax,[currentShapeY]
            add ax,[colorSquareLength]
            sub ax,3
            mov [yl],ax
            
            add ax,2
            mov [yMouse],ax
            
            call drawLineAndStore
            
             mov ax,[currentShapeX]
            add ax,4
            mov [xl],ax
            
            sub ax,3
            mov [xMouse],ax
            
            mov ax,[currentShapeY]
            add ax,6
            mov [yl],ax
            
            sub ax,5
            mov [yMouse],ax
            
            call drawLineAndStore
            
             mov ax,[currentShapeX]
            add ax,6
            mov [xl],ax
            
            sub ax,5
            mov [xMouse],ax
            
            mov ax,[currentShapeY]
            add ax,4
            mov [yl],ax
            
            sub ax,3
            mov [yMouse],ax
            
            call drawLineAndStore
            
            mov ebx,[stackPointer]
            mov ax,[ebx]
            add dword[stackPointer],2
            mov [yMouse],ax
            
            mov ebx,[stackPointer]
            mov ax,[ebx]
            add dword[stackPointer],2
            mov [xMouse],ax
            
            ret
            
            ret                                   
             
initializeColorSelectionArea:
                mov al,[lightGray]
                mov cx,[leftmostPixel]
                mov dx,0
                mov bx,[lowestPixel]
                mov [drawHorizontalRectangleCounter],bx
                mov bx,319
                call drawHorizontalRectangle
                
                mov al,[shapesColor]
                mov [currentColor],al
                
                mov al,[gray]
                mov cx,[penX]
                mov dx,[penY]
                mov bx,[colorSquareLength]
                mov [drawHorizontalRectangleCounter],bx
                add bx,cx
                call drawHorizontalRectangle
                call drawPenShape
                
                mov al,[gray]
                mov cx,[lineX]
                mov dx,[lineY]
                mov bx,[colorSquareLength]
                mov [drawHorizontalRectangleCounter],bx
                add bx,cx
                call drawHorizontalRectangle
                call drawLineShape
                
                mov al,[gray]
                mov cx,[rectangleX]
                mov dx,[rectangleY]
                mov bx,[colorSquareLength]
                mov [drawHorizontalRectangleCounter],bx
                add bx,cx
                call drawHorizontalRectangle
                call drawRectangleShape
                
                
                mov al,[gray]
                mov cx,[circleX]
                mov dx,[circleY]
                mov bx,[colorSquareLength]
                mov [drawHorizontalRectangleCounter],bx
                add bx,cx
                call drawHorizontalRectangle
                call drawCircleShape
                
                
                mov al,0x00
                mov cx,[blackX]
                mov dx,[blackY]
                mov bx,[colorSquareLength]
                mov [drawHorizontalRectangleCounter],bx
                add bx,cx
                call drawHorizontalRectangle
                
                mov al,0x03
                mov cx,[cianX]
                mov dx,[cianY]
                mov bx,[colorSquareLength]
                mov [drawHorizontalRectangleCounter],bx
                add bx,cx
                call drawHorizontalRectangle
                
                mov al,0x0a
                mov cx,[greenX]
                mov dx,[greenY]
                mov bx,[colorSquareLength]
                mov [drawHorizontalRectangleCounter],bx
                add bx,cx
                call drawHorizontalRectangle
                
                mov al,0x01
                mov cx,[blueX]
                mov dx,[blueY]
                mov bx,[colorSquareLength]
                mov [drawHorizontalRectangleCounter],bx
                add bx,cx
                call drawHorizontalRectangle
                
                mov al,0x04
                mov cx,[redX]
                mov dx,[redY]
                mov bx,[colorSquareLength]
                mov [drawHorizontalRectangleCounter],bx
                add bx,cx
                call drawHorizontalRectangle
                
                mov al,0x0f
                mov cx,[orangeX]
                mov dx,[orangeY]
                mov bx,[colorSquareLength]
                mov [drawHorizontalRectangleCounter],bx
                add bx,cx
                call drawHorizontalRectangle
                
                call drawCurrentShapeSquare
                
                mov al,[shapesColor]
                mov [currentColor],al
                call drawPenShapeC
                mov al,[initialCurrentColor]
                mov [currentColor],al
                
                call drawCurrentColorSquare
                call drawCurrentAuxilaryColorSquare
                ret
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawCurrentColorSquare:                
                mov al,[currentMainColor]
                mov cx,[currentColorX]
                mov dx,[currentColorY]
                mov bx,[colorSquareLength]
                mov [drawHorizontalRectangleCounter],bx
                add bx,cx
                call drawHorizontalRectangle
                ret
            
drawCurrentShapeSquare:                
                mov al,[gray]
                mov cx,[currentShapeX]
                mov dx,[currentShapeY]
                mov bx,[colorSquareLength]
                mov [drawHorizontalRectangleCounter],bx
                add bx,cx
                call drawHorizontalRectangle
                ret
                                    
drawCurrentAuxilaryColorSquare:                   
                mov al,[currentAuxilaryColor]
                mov cx,[currentAuxilaryColorX]
                mov dx,[currentAuxilaryColorY]
                mov bx,[colorSquareLength]
                mov [drawHorizontalRectangleCounter],bx
                add bx,cx
                call drawHorizontalRectangle
                
                ret
                
initializeMouse:
                xor eax, eax       ; aux input enable command
                call pollWrite
                mov al, 0xa8        
                out  0x64, al
	
                call pollWrite 
	mov al, 0xf6           ; set defaults: 100 packets/sec, 4 counts/mm, disable streaming
                call writeMouse

                
                call pollWrite
	mov al, 0xf4           ; enable streaming
                call writeMouse
                ret
          
                

            
pollWrite:
    nextPollWrite:  
                in al, 0x64
                and al, 0x02
	jnz nextPollWrite
	ret
	  
pollRead:
    nextPollRead:  
                in al, 0x64
                and al, 0x01
	jz nextPollRead
	ret

writeMouse:
                mov bl, al
                mov al, 0xd4
                out 0x64, al
                call pollWrite
                mov al, bl
                out 0x60, al
                call pollRead
                call readMouse
                ret	  
                	
readMouse:
                in al, 0x60
                ret
                 hlt 
                
drawHorizontalLine:       ; al color, cx left point , dx hight, bx right point       
                cmp cx,bx
                jb continueDrawingHorizontalLine  
                xchg cx,bx    
    continueDrawingHorizontalLine:     
                mov ah,0x0C	;change color for a single pixle
	int 0x10
                inc cx
                cmp cx,bx
                jbe continueDrawingHorizontalLine
                ret
                
                
drawHorizontalRectangle:        ; al color, cx left point , dx top point, bx right point
    nextdrawHorizontalRectangle:
                cmp word[drawHorizontalRectangleCounter],0
                jbe donedrawHorizontalRectangle
                push cx
                push bx
                call drawHorizontalLine
                pop bx
                pop cx
                inc dx
                dec word[drawHorizontalRectangleCounter]
                jmp nextdrawHorizontalRectangle
    donedrawHorizontalRectangle:
                ret
               
      ; left & right
setMouseStatus:
	call readMouse
                mov byte [statusMouse], al
                mov bl,al
	and al,0x01
	mov [leftButtonMouse],al
                
                and bl,0x02
                mov [rightButtonMouse],bl 
                ret
                
setXMouse:
                ; x displacement
	xor ax,ax
	xor dx,dx
	call readMouse
	movsx dx,al
                add [xMouse], dx
	  
	  
	cmp word[xMouse],0  ;x boundaries
	jg rightBound
	mov word[xMouse],0
	
    rightBound:
	cmp word[xMouse],319 ;x boundaries
	jl doneDeltaX
	mov word[xMouse],319
    doneDeltaX:
                ret
                
setYMouse:
                ; y displacement
	xor ax,ax 
	xor dx,dx
                call readMouse
	movsx dx,al
                sub [yMouse], dx  
    
	  
	cmp word [yMouse],199  ;y boundaries
	jl UP
	mov word[yMouse],199
       
    UP:
	cmp word [yMouse],0   ; boundaries
	jg doneDeltaY
	mov word [yMouse],0
    doneDeltaY:                
                ret
                
setZMouse:
                call readMouse
                mov byte [zMouse], al
                ret
                
storeLastPixelColor:
                mov ah,0x0d
                mov cx,[xMouse]         ; x
                mov dx,[yMouse]         ; y
                int 0x10
                mov [lastPixelColor],al 
                
                inc cx
                cmp cx,319
                jg skipleft
                
                int 0x10
                mov [lastPixelColor1],al 
skipleft:
                inc dx
                cmp dx,199
                jg skipdown
                
                int 0x10
                mov [lastPixelColor2],al 
                
                dec cx
                int 0x10
                mov [lastPixelColor3],al 
skipdown:                
                ret
                
restoreLastPixelColor:
                mov ah,0x0C	;change color for a single pixle
	mov al,[lastPixelColor]	; retain color
	mov cx,[xMouse] 	; x
	mov dx,[yMouse] 	; y
	int 0x10

                inc cx
                cmp cx,319
                jg skipleft1
                mov al,[lastPixelColor1]	; retain color
	int 0x10
skipleft1:
                
                inc dx
                cmp dx,199
                jg skipdown1
                mov al,[lastPixelColor2]	; retain color
	int 0x10

                dec cx
                mov al,[lastPixelColor3]	; retain color
	int 0x10
skipdown1:              
                ret
                
                
oldRestoreLastPixelColor:
                mov ah,0x0C	;change color for a single pixle
	mov al,[lastPixelColor]	; retain color
	mov cx,[xMouse] 	; x
	mov dx,[yMouse] 	

                inc cx
                cmp cx,319
                jg skipleft11
                mov al,[lastPixelColor1]	; retain color
	int 0x10
skipleft11:
                
                inc dx
                cmp dx,199
                jg skipdown11
                mov al,[lastPixelColor2]	; retain color
	int 0x10

                dec cx
                mov al,[lastPixelColor3]	; retain color
	int 0x10
skipdown11:              
                ret
                
                
generalRestoreLastPixelColor:
                mov al,[currentColor]
                mov [temporaryColor],al
	mov al,[lastPixelColor]	; retain color
	mov cx,[xMouse] 	; x
	mov dx,[yMouse] 	; y
                mov [currentColor],al
                mov esi,restoreCounter
                call draw
                
                mov al,[lastPixelColor1]	; retain color
                inc cx
                mov [currentColor],al
                mov esi,restoreCounter
                call draw
                
                mov al,[lastPixelColor2]	; retain color
                inc dx
                mov [currentColor],al
                mov esi,restoreCounter
                call draw
                
                mov al,[lastPixelColor3]	; retain color
                dec cx
                mov [currentColor],al
                mov esi,restoreCounter
                call draw
                
                mov al,[temporaryColor]
                mov [currentColor],al
	
                ret

                
showPointer:
	mov  cx, [xMouse]	; x
	mov  dx, [yMouse]
                mov esi,restoreCounter
                mov byte[drawAvailability],1
                call draw
                inc cx
                call draw
                inc dx
                call draw
                dec cx
                call draw
                mov byte[drawAvailability],0
                ret

oldShowPointer:
	mov  cx, [xMouse]	; x
	mov  dx, [yMouse]
                mov esi,restoreCounter
                call draw
                ret              
isMouseInsideColorSelectionArea:
                mov cx,[leftmostPixel]
                mov bx,319
                sub bx,cx
                mov dx,0
                mov ax,[lowestPixel]
                call isMouseInsideHorizontalRectangle
                ret
                
isMouseInsideHorizontalRectangle:
                cmp [xMouse],cx
                jb mouseNotInsideHorizontalRectangle
                add cx,bx
                cmp [xMouse],cx
                ja mouseNotInsideHorizontalRectangle
                cmp [yMouse],dx
                jb mouseNotInsideHorizontalRectangle
                add dx,ax
                cmp [yMouse],dx
                ja mouseNotInsideHorizontalRectangle
                mov al,1
                ret
    mouseNotInsideHorizontalRectangle:
                xor al,al
                ret
QUIT_PAINTER:
                mov ax,0x03     ; graphical mode 320x200 pixles 256 colors
                int 0x10	       ; set video mode
                jmp OS
                hlt
times 8192-($-Painter) db 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Others:
nop
ClearScreen2:
        mov ecx, -1
        mov edi, 0xB80A0
        loopCLR2:
        inc ecx
        cmp ecx, 2000;total number of characters
        jge CLR2
        shl ecx, 1
        mov byte[edi+ecx], 0
        shr ecx, 1
        jmp loopCLR2
        CLR2:
        ret
ClearScreen:
        mov ecx, -1
        mov edi, 0xB8000
        loopCLR3:
        inc ecx
        cmp ecx, 2000;total number of characters
        jge CLR3
        mov byte[edi], 0
        add edi, 2
        jmp loopCLR3
        CLR3:
        mov edi, 0xB8000
        ret
printString:
        ;mov edi, 0xB8020
        mov ecx, -1
        loop1print:
            inc ecx
            mov al, [esi+ecx]
            cmp al, 0
            je end1print
            mov byte[edi], al
            add edi, 2
            jmp loop1print
        end1print:
        ret
cmpString:
    mov ecx, -1
    loopcmpStr:
    inc ecx
    mov al, [esi+ecx]
    cmp al, 0
    je almost
    cmp byte[edi+ecx], al
    jne noteql
    jmp loopcmpStr
    almost:
    cmp byte[edi+ecx], 0
    jne noteql
    jmp eql
    noteql:
    mov ax, 0
    ret
    eql:
    mov ax, 1
    ret
GENRAND:
        mov ebx, edx
        sub ebx, ecx
        add ebx, 1
        xor eax, eax        
        rdtsc
        shr eax, 2
        cdq
        div ebx
        add edx, ecx
        mov eax, edx
        ;call printNum
        xor ebx, ebx
        xor edx, edx
        xor ecx, ecx
        ret
 printNum:
        r4:
        cmp eax, 0
        jne E7
        mov byte[edi], '0'
        ret
        E7:
        mov ecx, -1
        loopres:
            inc ecx
            cmp eax, 0
            je endres
            cdq
            mov ebx, 10
            div ebx
            and edx, 0xf
            add edx, 0x30
            mov byte[VALUE+ecx], dl
            jmp loopres
         endres:
        mov esi, ecx
        mov ecx, -1
        mov ebx, esi
        loop02:
            inc ecx
            dec ebx
            cmp ecx, esi
            jge end01
            mov al, [VALUE+ebx]
            cmp al, 0
            je end01
            mov byte[edi], al
            add edi, 2
            jmp loop02
end01:
ret
times 1024-($-Others) db 0
DATA:
    gameOver: db 'f'
    x: dd 40
    y: dd 12
    fruitX: dd 40
    fruitY: dd 13
    scoreS: dd 0
    nTail: dd 3
    dir: db 'r'
    difficulty: dd 2
    d: dd 2
    mode: dd 0
    m dd 0
    tailX: times(100) dd 0
    tailY: times(100) dd 0
    prevX: dd 0
    prevY: dd 0
    prev2X: dd 0
    prev2Y: dd 0 
    pp: db 'f'
    result: times(20) db 0
    location:dw 0
    command: times(15)db 0
    exp: times(20) db 0
    VALUE: times(20) db 0
    n: dd 20
    num1: dd 0
    num2: dd 0
    op: db 0
    
    winner: db 0
    pad1: dd 10
    pad2: dd 10
    padsize: dd 4
    ballX: dd 40
    ballY: dd 12
    ballspeedX: dd 1
    ballspeedY: dd 1
    direction: db 'R', 'U'
    GAmeOVer: db 'f'
    MaxScoreP: dd 8
    dP: dd 2
    modeP:dd 1
    scoreP:dd 0,0
    
    


spryCounter : dd 0
xc: dw 50,0
yc: dw 50,0
;x: dw 0,0
;y: dw 0,0
r: dw 40,0
xn: dw 70,0
yn: dw 50,0
;p: dw 1, 0
ycd: dd 0,0
xcd: dd 0,0
xmd: dd 0,0
ymd: dd 0	,0
rd: dd 0,0
xl: dw 0,0
yl: dw 0,0
xdot1: dw 0,0
ydot1: dw 0,0
xdot2: dw 0,0
ydot2: dw 0,0
xnew: dw 0,0
ynew: dw 0,0
yold: dw 0,0

xGuess : dd 0
yGuess : dd 0


xr :dw 0
yr :dw 0


;r  : dd 0
leftButtonColor: db 0x0f
;rightButtonColor: db 0
	
;for debug
xMouse1: dw 100
yMouse1 : dw 50 
counter:dw 0
X: dw 0x00
    Y: dw 0x00

    currentMainColor: db 0x00
    buttoN: db 0
    restoreCounter: times (2000) db 0
    stackLength: dd 300
    stackPointer: dd 0
    stackBase: times(300) db 0
times 8192-($-DATA) db 0
times (0x400000 - 512) db 0
db 	0x63, 0x6F, 0x6E, 0x65, 0x63, 0x74, 0x69, 0x78, 0x00, 0x00, 0x00, 0x02
db	0x00, 0x01, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
db	0x20, 0x72, 0x5D, 0x33, 0x76, 0x62, 0x6F, 0x78, 0x00, 0x05, 0x00, 0x00
db	0x57, 0x69, 0x32, 0x6B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x78, 0x04, 0x11
db	0x00, 0x00, 0x00, 0x02, 0xFF, 0xFF, 0xE6, 0xB9, 0x49, 0x44, 0x4E, 0x1C
db	0x50, 0xC9, 0xBD, 0x45, 0x83, 0xC5, 0xCE, 0xC1, 0xB7, 0x2A, 0xE0, 0xF2
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00