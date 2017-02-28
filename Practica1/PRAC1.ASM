		DEFSEG	INICIO1,ABSOLUTE
		SEG		INICIO1
		JMP		INICIO
		ORG		100H		; Direccion de inicio del programa
	
INICIO:	MOV		PSW,#00H	; Seleccion del banco de registro 0
							; La memoria 30H debe inicializarse con el numero de elementos
							; a generar
		MOV		R0,30H		; Se carga el contenido de la direccion 30H en R0
		MOV		R1,#40H		; El primer numero de la sucesion es almacenado en la direccion 40H
		MOV		@R1,#00H	; El valor '0' es cargado a la posicion 40H
		INC		R1			; Incrementa el valor de R1 desde 40H a 41H
		MOV		@R1,#01H	; Se carga el valor de '1' en la posicion 41H
		
		MOV		PSW,#08H	; Seleccion del banco de registro 1
		MOV		R0,#42H		; R5 es cargado con la direccion 42H,
							; para almacenar el proximo vamor de la serie
		MOV		PSW,#00H	; Seleccion del banco de registro 0
		DEC		R0			; R0 disminuye en dos unidades debido a que ya
		DEC		R0			; se generaron los primeros dos numeros
		
		DEC		R1			; R1 es ahora reducido desde 41H a 40H
LOOP:	MOV		A,@R1		; El contenido de R1 es cargado al acumulador

		INC		R1			; R1 es incrementado para obtener el proximo valor
		ADD		A,@R1		; Los dos valores son sumados y el resultado es cargado al acumulador

		; ESTA ES LA MODIFICACION QUE PIDE HACER EL ENUNCIADO PARA CONVERTIR A DECIMAL
        DA      A           ; Se convierte a decimal el resultado
		
		MOV		PSW,#08H	; Seleccion del banco de registro 1
		MOV		@R0,A		; El nuevo valor generado por la suma de los dos anteriores
							; es cargado en R0
		INC		R0			; R0 se incrementa para almacenar el proximo valor
		
		MOV		PSW,#00H	; Seleccion del banco de registro 0
		DJNZ	R0,LOOP		; N=N-1 ; N!=0 SI -> ir a LOOP
		
FIN:	NOP
		END
