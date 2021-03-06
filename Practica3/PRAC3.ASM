N 		EQU		05H			; TAMAÑO DEL VECTOR
M 		EQU		06H			; TAMAÑO DEL VECTOR -1
I		EQU		02H			; INDICE FOR EXTERNO
J		EQU		03H			; INDICE FOR INTERNO
AUX		EQU		07H			; AUXILIAR PARA INTERCAMBIO
INTE1 	EQU 	2EH			; CONTADOR PARA INTERCAMBIO
INTE2 	EQU 	2FH			; CONTADOR PARA INTERCAMBIO
RQ4		EQU		04H			; USO PARA GENERADOR DE LETRA
RAND	EQU		2DH			; USO PARA GENERADOR DE LETRA

		DEFSEG	INICIO1,ABSOLUTE
		SEG		INICIO1
		JMP		PRINC
		ORG 	100H			; DIRECCION DE INICIO DEL PROGRAMA
		
PRINC:  ; INICIO DEL PROGRAMA PRINCIPAL
		MOV 	N,#2BH			; INICIALIZA N=16
		MOV 	M,#2AH			; INICIALIZA M=N-1=15. NOTA. M ES N-1
		MOV 	I,#00H			; INICIALIZACION I=0
		MOV 	J,#00H			; INICIALIZACION J=0
		MOV 	INTE1,#00H		; INICIALIZA 2E = 0
		MOV 	INTE2,#00H		; INICIALIZA 2F = 0
		
		MOV A,R5				; MUEVE EL CONTENIDO DE R5 AL ACUMULADOR
		MOV RQ4,A				; MUEVE EL CONTENIDO DEL ACUMULADOR A LA DIRECCION DE RQ4
		DEC	R5					; DECREMENTA EL REGISTRO R5
		MOV R0, #30H			; MUEVE LA DIRECCION 30H AL REGISTRO R0
		MOV A,R5 				; MUEVE EL CONTENIDO DE R5 AL ACUMULADOR
		MOV RAND, A				; MUEVE EL CONTENIDO DEL ACUMULADOR A LA DIRECCION DE RAND
		
LLENAR: LCALL RANDOM			; LLAMADA AL PROCEDIMIENTO RAMDOM
		MOV A, RAND				; MUEVE EL CONTENIDO DE RAND AL ACUMULADOR
		MOV B,#1AH				; MUEVE LA DIRECCION 1AH AL REGISTRO B
		DIV AB					; DIVIDE A ENTRE B
		MOV A,B					; SE LE ASIGNA EL NUEVO X DEL RAMDOM
		ADD A,#41H				; MUEVE LA DIRECCION 41H AL ACUMULADOR A
		MOV @R0, A				; MUEVE EL ACUMULADOR AL CONTENIDO DEL REGISTRO R0		
		INC R0					; INCREMENTA EN 1 EL REGISTRO R0
		
FLLENAR: DJNZ RQ4, LLENAR
				
VALI:	CLR 	A				; VALIDANDO QUE N SEA <= QUE LA CANTIDAD MAXIMA DE ELEMENTOS DEL VECTOR (4FH)
		MOV 	A,#4FH			;
		CLR 	C				;
		SUBB	A,N				;
		JC		ERROR			; SI NO ES VALIDO, SALTA AL MENSAJE DE ERROR Y FINALIZA EL PROGRAMA.

		LCALL	ORDLET			; LLAMADA AL PROCEDIMIENTO ORDENAR LETRAS (ORDLET)
	
ORDLET:	
		PUSH	30H				; PRESERVANDO DIRECCION DE INICIO
		PUSH 	05H				; PRESERVANDO DIRECCION DE N (NUMERO DE ELEMENTOS DEL VECTOR)
		
RANGO:	MOV A,J					; VALIDANDO QUE EL ELEMENTO J SEA >= QUE 'A'
		ADD A,#30H				;
		MOV R0,A				;
		CLR C					;
		CLR AC					;
		MOV A,@R0				;
		SUBB A,#41H				; SI LA RESTA GENERA ACARREO 1, SALTA A ERROR Y FINALIZA EL PROGRAMA
		JC ERROR
		
		CLR C					; SINO PROCEDE A VALIDAR QUE EL ELEMENTO J SEA <= QUE 'Z'
		CLR AC					;
		MOV A,@R0				;
		SUBB A,#5BH				; SI LA RESTA GENERA ACARREO 0, SALTA A ERROR Y FINALIZA EL PROGRAMA
		JNC ERROR				;
		
		MOV A,J					; SINO AUMENTA EL INDICE Y SIGUE ITERANDO HASTA M POSICIONES
		CJNE A,M,INCJJ			;
		JMP ICLZ				;
		
INCJJ:	INC J					; INCREMENTANDO J EN 1 PARA ITERAR EN EL CICLO DE VALIDACION DE RANGO
		JMP RANGO				;
		
ICLZ:	MOV J,#00H				; INICIALIZACION J=0
		CLR A					; INICIALIZACION A=0
		
COND:	MOV A,J					; CONDICION (J>J+1)
		ADD A,#30H				; SE SUMA 30 (DIRECCION DONDE INICIA EL VECTOR) AL VALOR DE J QUE SE ENCUENTRA EN A
		CLR C
		MOV R0,A				; ASIGNAMOS LA DIRECCION DEL ELEMENTO J A LA DIRECCION R0 (QUE ES UN APUNTADOR)
		ADD A,#01H				; INCREMENTAMOS A EN 1 (QUEDANDO A CON EL VALOR DE J+1)
		MOV R1,A				; ASIGNAMOS EL ELEMENTO A (J+1) AL APUNTADOR R1
		MOV A,@R1				; EL ELEMENTO AL CUAL APUNTA R1 SE LO ASIGNAMOS A A
		SUBB A,@R0				; RESTAMOS AMBOS REGISTROS (R1-R0), SI OBTENEMOS UN NUMERO NEGATIVO, SABEMOS QUE J > J+1
		CLR AC					;
		JC LINTER				; DE SER ACARREO 1, SALTAMOS A LA ETIQUETA DE INTERCAMBIO
		JMP INCRJ				; SINO INCREMENTA EL CONTADOR J

LINTER: LCALL INTER				; LLAMADA A INTERCAMBIO
		
INCON1:	MOV A,INTE2				; UNA VEZ HECHO EL INTERCAMBIO,
		INC A					; SE INCREMENTA EL CONTADOR INTE2 EN 1
		CLR C					;
		CLR AC					;
		DA A					;
		MOV INTE2,A				;
		CJNE A,#99H,INCRJ		; SI INTE2 ES DISTINTO DE 99 (NUMERO MAXIMO DE INTERCAMBIOS), SALTA A LA ETIQUETA INCRJ
		
		MOV INTE2,#00H			; SINO, ES PORQUE LLEGO A 99 ELEMENTOS, 
		CLR A					; E INICIALIZA INTE2 EN 00
		MOV A,INTE1				; E INCREMENTA EL CONTADOR DE INTERCAMBIO INTE1
		INC A					;
		CLR C					;
		CLR AC					;
		DA A					;
		MOV INTE1,A				;
		JMP INCRJ				; SALTO A LA ETIQUETA INCRJ
		
INCRJ:	INC J					; INCREMENTAR J EN 1
		CLR C					;
		MOV A,J					;
		CJNE A,M,COND			; VERIFICA SI J ES DISTINTO DE M(N-1) Y SALTA A COND
		
		;~ CLR A				; TRANSFORMAR A DECIMAL
		;~ MOV A,J				; CON ESTA TRANSFORMACION NO ORDENA EL VECTOR COMPLETO
		;~ INC A				;
		;~ CLR C				;
		;~ CLR AC				;
		;~ DA A					;
		;~ MOV J,A				;
		;~ CJNE A,M,COND		;
		
INCRI:	INC I					; SINO CONTINUA SALIENDO DEL FOR INTERNO AL FOR EXTERNO INCREMENTANDO I EN 1
		CLR C					;
		MOV A,I					;
		CJNE A,M,ICLZ			; VERIFICA SI I ES DISTINTO DE M(N-1) Y SALTA A INCLZ
								; SI SON IGUALES ES PORQUE YA VERIFICO TODO EL VECTOR Y CONTINUA A LA ETIQUETA FIN
		
		;~ CLR A				; TRANSFORMAR A DECIMAL
		;~ MOV A,I				; CON ESTA TRANSFORMACION NO ORDENA EL VECTOR COMPLETO
		;~ INC A				;
		;~ CLR C				;
		;~ CLR AC				;
		;~ DA A					;
		;~ MOV I,A				;
		;~ CJNE A,N,ICLZ		;
		
		; RESTAURAR PARAMETROS
		;POP 	05H		; RESTAURANDO DIRECCION DE INICIO
		;POP 	30H		; RESTAURANDO DIRECCION DE N (NUMERO DE ELEMENTOS DEL VECTOR)
		RET
		JMP 	FIN
; MENSAJE DE ERROR		
ERROR:	MOV 	19H,#'E'		; MENSAJE DE ERROR
		MOV 	1AH,#'R'		;
		MOV 	1BH,#'R'		;
		MOV 	1CH,#'O'		;
		MOV 	1DH,#'R'		;
		MOV 	1EH,#'!'		;
		JMP 	FIN				; SALTO A LA ETIQUETA FIN
		
; PROCEDIMIENTOS
INTER:	; PROCEDIMIENTO DE INTERCAMBIO
		PUSH 00H				; PRESERVANDO REGISTRO R0
		PUSH 01H				; PRESERVANDO REGISTRO R1
		MOV A,@R0				; INTERCAMBIO DE LOS ELEMENTOS J Y J+1 HACIENDO USO DE LOS REGISTROS R0 Y R1
		MOV AUX,A				;
		MOV A,@R1				;
		MOV @R0,A				;
		MOV A,AUX				;
		MOV @R1,A				;
		POP 01H					; RESTAURANDO REGISTRO R1
		POP 00H					; RESTAURANDO REGISTRO R1
		RET						; RETORNO
; FIN RPOCEDIMIENTO INTERCAMBIO		
; PROCEDIMIENTO DE RAMDOM (GENERAR LETRAS ALEATORIAS)
RANDOM:	PUSH 00H
		PUSH 01H
RAND8:	MOV	A, RAND
		JNZ	RAND8B
		CPL	A
		MOV	RAND, A
		
RAND8B:	ANL A, #10111000b
		MOV	C, P
		MOV	A, RAND
		RLC	A
		MOV	RAND, A
		POP 01H
		POP 00H
		RET
; FIN DEL PROCEDIMIENTO RAMDOM
FIN:	NOP
		END
