; Arquitectura del Computador
; Practica 2
; Icler Anaya           - 24.450.482
; Wilsen Hernandez      - 24.993.998

; DEFINICION DE VARIABLES DE REGISTRO
; GLOBALES
N       EQU     05H             ; N <=> R5
I       EQU     00H             ; I <=> R0
JI      EQU     08H             ; j <=> R0'
JIP     EQU     09H             ; j+1 <=> R1'
IN0     EQU     2FH             ; 8 bits inferiores contador de swaps
IN1     EQU     2EH             ; 8 bits superiores contador de swaps

; DEFINICION DE TEMPORALES --- Just in case
TEMP0   EQU     20H             ; T0 <=> 20H
TEMP1   EQU     21H             ; T1 <=> 21H
TEMP2   EQU     22H             ; T2 <=> 22H
TEMP3   EQU     23H             ; T3 <=> 23H
TEMP4   EQU     24H             ; T4 <=> 24H
TEMP5   EQU     25H             ; T5 <=> 25H
TEMP6   EQU     26H             ; T6 <=> 26H
TEMP7   EQU     27H             ; T7 <=> 27H

        DEFSEG  INICIO1, ABSOLUTE
        SEG     INICIO1
        JMP     INICIO
        ORG     100H

; **********************************************

        ; INICIALIZACIÓN DE N
INICIO: 
        MOV     PSW,#00H                ; SELECCIONA BANCO DE REGISTROS 1
        MOV     A,N                     ; IF (N != 0) Generar valores
        JNZ     VERIF                   ; ELSE Generar (7FH - 30H) valores
        MOV     A,#7FH                  ; ACC <- 7FH
        SUBB    A,#30H                  ; ACC <- 7FH - 30H
        INC     A
        MOV     N,A                     ; N <- 7FH - 30H (N TOTAL DE POSICIONES DEL REGISTRO)
        JMP     GENERAR
VERIF:  MOV     A,N                     ; A <- N
        CJNE    A,#4FH,VERIF2           ; IF (N < 7FH-30H)
        JMP     GENERAR                 ; N = 7FH - 30H
VERIF2: JC      GENERAR                 ; IF CY=1 THEN N<7FH-30H
        JMP     INICIO

; **********************************************

        ; GENERAR VALORES PSEUDOALEATORIOS
        ; UTILIZANDO EL METODO DE CONGRUENCIA LINEAL MIXTA
GENERAR:
        MOV     I,N                     ; i <- N
        MOV     R1,#30H                 ; &X[i] = R1 <- 30H
        MOV     R2,#05H                 ; A = R2 <- 5
        MOV     R3,#18H                 ; C = R3 <- 24
        MOV     R4,#1BH                 ; M = R4 <- 27
        MOV     R7,#07H                 ; X = R7 <- 7

GEN:    
        MOV     A,R2                    ; A <- amc 
        MOV     B,R7                    ; B <- X
        MUL     AB                      ; A <- amc * X
        ADD     A,R3                    ; A <- (amc * X + cmc)
        MOV     B,R4                    ; B <- 
        DIV     AB                      ; A <- (amc * X + cmc) / mmc
                                        ; B <- (amc * X + cmc) % mmc
        MOV     A,B
        MOV     R7,A                    ; X <- (amc * X + cmc) % mmc
        ADD     A,#40H                  ; A <- A + 64
        MOV     @R1,A                   ; X[i] <- (amc * X + cmc) % mmc
        INC     R1                      ; i++

        DJNZ    I,GEN
        MOV     R1,#00H
        MOV     R2,#00H
        MOV     R3,#00H
        MOV     R4,#00H
        MOV     R7,#00H

; **********************************************
        
        ; ALGORITMO DE ORDENAMIENTO BURBUJA
        ; BUBBLESORT
BUBBLE:                                 ; Inicialización OUTER LOOP
        MOV     R1,N                    ; Pasada = R1 <- N
        MOV     R2,#00H                 ; INDEX = 0

OUTERL:                                 ; Inicio del OUTER LOOP
                                        ; Inicialización INNER LOOP
        MOV     A,N
        SUBB    A,R2
        DEC     A
        JZ      FIN
        MOV     R3,A                    ; j = N - pasada - 1
        MOV     JI,#30H
        MOV     JIP,#31H
INNERL:                                 ; Inicio del INNER LOOP
        
        JMP     SWAP                    ; GOTO SWAP
SWPRET:                                 ; SWAP RETURN ADDRESS
        MOV     PSW,#00H
        INC     JI
        INC     JIP
                                        ; Comparacion INNER LOOP
        DJNZ    R3,INNERL               
        
                                        ; Comparacion OUTER LOOP
        INC     R2                      ; INDEX++
        DJNZ    R1,OUTERL

; **********************************************
        
        ; COMPARACION E INTERCAMBIO

SWAP:   MOV     PSW,#08H
        MOV     B,@R0                   ; B <- a[j]
        MOV     A,@R1                   ; A <- a[j+1]
        CLR     C
        CJNE    A,B,NEQL

NEQL:   JC      SWP
        MOV     PSW,#00H
        JMP     SWPRET

SWP:    MOV     A,@R0
        XCH     A,@R1
        MOV     @R0,A
        MOV     PSW,#00H
        JMP     CONT

; **********************************************

        ; CONTADOR DE SWAPS DE 16 BITS
CONT:   
        MOV     A,IN0
        ADD     A,#01H                  ; Contador_inferior++
        MOV     IN0,A
        JNC     SWPRET
        INC     IN1                     ; Contador_superior++
        JMP     SWPRET                  ; Return from swap

; **********************************************

FIN:    NOP                             ; FIN DE LA PESADILLA
        END                             ; YA ME DIO DOLOR DE CABEZA
