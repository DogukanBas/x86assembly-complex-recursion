datasg SEGMENT PARA 'veri'
    ARRAY dw 1000 dup(0)
    SAYI DW 500
datasg ends

stacksg SEGMENT PARA STACK 'stck'
    DW 256 DUP(?) 
stacksg ends


codesg SEGMENT PARA 'kod'
    ASSUME CS:codesg, SS:stacksg, DS:datasg
   
MAIN PROC FAR
    PUSH DS
    XOR AX,AX
    PUSH AX
    MOV AX,datasg
    MOV DS,AX


    MOV WORD PTR ARRAY[2],1      ;N=1 ==>1
    MOV WORD PTR ARRAY[4],1      ;N=2 ==>1

    MOV AX, SAYI
    PUSH AX
    CALL FAR PTR DNUM
    CALL FAR PTR PRINTINT
    POP AX
    
    RETF 
MAIN ENDP


DNUM PROC FAR
    PUSH BP
    MOV BP,SP  
    PUSH BX
    PUSH DX
    PUSH AX

    MOV BX, [BP+6]              ;BX<--N
    
    SHL BX,1                    ;BX = BX*2
    MOV AX,ARRAY[BX]            ;AX<--ARRAY[N]
    SHR BX,1                    ;BX=BX/2

    CMP AX,0                    ;ilgili eleman daha once hesaplanmis mi?
    
    JNE DYNAMIC                 ; hesaplandiysa recursiona gerek yok direkt sonuca git.

    CMP BX,3
    JAE L3  ;N>=3
    CMP BX,0;
    JNE L2  ;N=1 veya N=2

                                ;N=0
    MOV WORD PTR [BP+6],0
    jmp EXIT

DYNAMIC:
    MOV [BP+6],AX
    jmp EXIT

L2:
                                 ;N=1 veya N=2

    MOV WORD PTR [BP+6],1
    jmp EXIT


L3: 
                               ;N>=3

    DEC BX                     ;BX<--N-1 
    PUSH BX
    CALL FAR PTR DNUM          ; d[n-1] 
    CALL FAR PTR DNUM          ; d[d[n-1]] 
    POP AX                     ;d[d[n-1]] 

    DEC BX                     ; BX<--N-2    
    PUSH BX
    CALL FAR PTR DNUM   
    POP DX                      ; D[n-2 ] 

    INC BX                     ;BX<-- N-1
    SUB BX, DX                 ;(N-1 - D[N-2])
    
    PUSH BX
    CALL FAR PTR DNUM 
    POP BX                      ; D(N-1-D(N-2)) 
    
    ADD AX,BX                   ; D(D(N-1))+ D(N-1-D(N-2))
    
    MOV BX,[BP+6]                ;  bx=n
    SHL BX,1 
    MOV ARRAY[BX], AX             ; d[n]
    SHR BX,1;

    MOV [BP+6],AX

EXIT:
    POP AX
    POP DX
    POP BX
    POP BP
    RETF 

DNUM ENDP

PRINTINT PROC FAR

    PUSH BP
    MOV BP,SP
    PUSH BX
    PUSH AX
    PUSH CX
    PUSH DX
    
    XOR CX ,CX
    MOV AX, [BP+6]
    MOV BX,10

PUSH_TO_STACK: 
    XOR DX,DX
    DIV BX
    PUSH DX               ; sırasıyla basamaktaki elemanları pushla
    INC CX                ;basamak sayisi
    CMP AX,0             ; bolum=0 ise sayının tüm basamakları gezilmiştir
    JZ READ_FROM_STACK
    
    JMP PUSH_TO_STACK

READ_FROM_STACK:
    ;tek tek basamaklari stackten cekip, asci ile toplayıp sonucu bulabilir ve basamak basamak ekrana yazdirabiliriz
    POP DX
    ADD DX, '0'

    MOV AH,2
    INT 21H

    LOOP READ_FROM_STACK

    POP DX
    POP CX
    POP AX
    POP BX
    POP BP
    RETF 
PRINTINT ENDP


codesg ends
end MAIN
