; Arquitectura del Computador
; Practica 2
; Wilsen Hernandez - 24.993.998

; DEFINICION DE VARIABLES DE REGISTRO
; GLOBALES

N       EQU     05H                     ; N     REGISTRO 00H
TEMP    EQU     06H                     ; TEMP  REGISTRO 06H
TEMP2   EQU     07H                     ; TEMP2 REGISTRO 07H

; VARIABLES METODO DE LAS CONGRUGENCIAS

X       EQU     01H                     ; X     REGISTRO 01H
AMC     EQU     02H                     ; AMC   REGISTRO 02H
CMC     EQU     03H                     ; CMC   REGISTRO 03H
MMC     EQU     04H                     ; MMC   REGISTRO 04H

; CONTADORES DE CICLOS

I       EQU     0DH                     ; I     REGISTRO 0DH
PASA    EQU     0EH                     ; PASA  REGISTRO 0EH
NP1     EQU     0FH                     ; IP1   REGISTRO 0FH
AI      EQU     08H                     ; AI    REGISTRO 08H = A[i]
ASIG    EQU     09H                     ; ASIG  REGISTRO 09H = A[i+1]
IN0     EQU     2FH                     ; INT0  REGISTRO 2FH
IN1     EQU     2EH                     ; INT1  REGISTRO 2EH
        
        ;DEFSEG  INICIO1, ABSOLUTE
        ;SEG     INICIO1
        JMP     INICIO
        ORG     100H                    ; DIRECCION DE INICIO1
        
INICIO:
        ADD     A,#7FH                  ; ACC = 7FH
        SUBB    A,#30H                  ; ACC = 7FH - 30H
        INC     A                       ; ACC = 7FH - 30H + 1
        MOV     N,A                     ; N = 7FH - 30H + 1 (N TOTAL DE POSICIONES DEL REGISTRO)

        MOV     I,N                     ; 

        MOV     AI,#30H                 ; INICIALIZANDO LA POSICION DE INICIO DEL ARREGLO 30H
        MOV     X,#1EH                  ; INICIALIZANDO X EN #1EH = 30 DECIMAL
        MOV     AMC,#01H                ; INICIALIZANDO A EN #01H
        MOV     CMC,#03H                ; INICIALIZANDO C EN #03H
        MOV     MMC,#1BH                ; INICIALIZANDO M EN #1BH = 27 DECIMAL
        MOV     PSW,#08H
        
        ; GENERACION DEL ARREGLO MEDIANTE EL METODO DE LAS CONGRUGENCIAS
FILL:
        MOV     A,AMC                   ; ACC = A
        MOV     B,X                     ; BCC = Xn-1
        MUL     AB                      ; ACC = A*Xn-1
        ADD     A,CMC                   ; ACC = (A*Xn-1 + C)
        MOV     TEMP,A                  ; TEMP = (A*Xn-1 + C)
        MOV     B,MMC                   ; BCC = M
        DIV     AB                      ; ACC = (A*Xn-1 + C)/M
        CLR     C
        MOV     B,MMC                   ; BCC = M
        MUL     AB                      ; ACC = [(A*Xn-1 + C)/M]*M
        MOV     TEMP2,A
        MOV     A,TEMP
        SUBB    A,TEMP2
        MOV     X,A
        ADD     A,#41H
        MOV     PSW,#08H
        MOV     @R0,A
        
        ; CICLO DE LLENADO - FILL
        
        INC     AI
        DJNZ    I,FILL
        MOV     PSW,#00H
        
        ; LIMPIEZA DE VARIABLES UTILIZADAS PARA CALCULAR EL METODO DE LAS CONGRUGENCIAS
        
        MOV     X,#00H
        MOV     AMC,00H
        MOV     CMC,#00H
        MOV     MMC,#00H
        MOV     TEMP,#00H
        MOV     TEMP2,#00H
        MOV     AI,#00H
        
        ; INICIALIZACION DEL FOR EXTERNO DEL ALGORITMO DE LA BURBUJA
        ; PARA PASA <- 1 HASTA N EN 1 HACER
        ; for (int pasada = 0; pasada < N; pasada++)
        
        MOV     PASA,#00H
        
LOOP:   

        ; INICIALIZACION DEL FOR INTERNO DEL ALGORITMO DE LA BURBUJA
        ; PARA I <- 1 HASTA N - PASADA - 1 EN 1 HACER
        ; for (int i = 0; i < N - pasada - 1; i++)
        
        MOV     AI,#30H                 ; A[i] = 30H
        MOV     ASIG,#31H               ; A[i+1] = 31H
        MOV     I,#00H                  ; I = 0
        
        ; CALCULANDO N - PASADA - 1
        
        MOV     A,N                     ; ACC = N
        SUBB    A,PASA                  ; ACC = N - PASADA
        MOV     NP1,A                   ; NP1 = N - PASADA - 1
        
LOOP2:
        ; if (A[i] > A[i+1])
        
        JMP     VERF
        
IFFF:   MOV     PSW,#08H
        CLR     C
        MOV     A,@R1                   ; A = A[i+1]
        MOV     B,@R0                   ; A = A[i]
        CJNE    A,B,NEQL                ; A[i] > A[i+1]

CONTI:        
        ; COMPARACION LOOP INTERNO
        INC     AI
        INC     ASIG
        INC     I
        MOV     A,I
        CJNE    A,NP1,LOOP2
        
        ; COMPARACION LOOP EXTERNO
        INC     PASA                    ; PASADA++
        MOV     A,PASA                  
        CJNE    A,N,LOOP                ; PASADA < N
        JMP     FIN


NEQL:   JC      SWAP                  ; A[J] > A[J+1] == TRUE -> SWAP THAT SHIET
        JMP     CONTI

SWAP: 
        MOV     PSW,#08H
        MOV     A,@R0                   ; A = X
        MOV     B,@R1                   ; B = Y
        
        MOV     @R1,A                   ; X = B
        MOV     @R0,B                   ; Y = A

        CLR     C
        MOV     A,IN0
        ADD     A,#01H                  ; INCREMENTAR EL CONTADOR DE SWAP
        MOV     IN0,A
        JC      INC2E
        JMP     CONTI                   ; SWAP COMPLETADO, GG WP
        
INC2E:  MOV     A,IN1
        ADD     A,#01H
        MOV     IN1,A
        JMP     CONTI

VERF:
        MOV     A,ASIG
        CJNE    A,#80H,IFFF
        JMP     CONTI

        
FIN:    NOP                             ; FIN DE LA PESADILLA
        END                             ; YA ME DIO DOLOR DE CABEZA
