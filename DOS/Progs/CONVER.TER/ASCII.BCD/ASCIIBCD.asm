INCLUDE dos.inc
INCLUDE minica2.inc
;*****************************************************************************
;����� �८�ࠧ������ �᫠ � ASCII-�।�⠢����� � ��㯠�������� BCD-�᫮
;*****************************************************************************
;�室: ��� ��६�����, ᮤ�ঠ饩 �����筮� �᫮ �  ASCII-�।�⠢�����,
;� ⠪�� ����� �⮩ ��६����� � �����.
;��室: � �� ��६�����, ᮤ�ঠ�� ��㯠�������� BCD-�᫮
;� ���浪�� ᫥������� ���� -  ����訩 ���� �� ����襬� ����� (Intel).
;*****************************************************************************
ASCII2BCD	MACRO	_var, _len
local	M1
	push	ax		;store registers
	push	bx
	push	cx
	push	si
	xor	bx, bx		;bx - ᫥�� ���ࠢ�
	mov	si, _len
	dec	si		;si - right to left
M1:
	mov	al, _var[bx]	;store 1 byte
	mov	ah, _var[si]	;store 1 byte
	sub	al, 30h		;convert byte value to ASCII-keycode
	sub	ah, 30h		;convert byte value to ASCII-keycode
	mov	_var[si], al	;swap
	mov	_var[bx], ah	;swap
	inc	bx
	dec	si
	cmp	bx, si
	jl	M1
	pop	si		;restore registers
	pop	cx
	pop	bx
	pop	ax
		ENDM
;*****************************************************************************
;����� �८�ࠧ������ BCD-�᫠ � ��� ASCII-�।�⠢�����
;*****************************************************************************
;�室: ��६�����, ᮤ�ঠ�� ��㯠�������� BCD-�᫮
;� ���浪�� ᫥������� ���� -  ����訩 ���� �� ����襬� ����� (Intel),
;� ⠪�� ����� �⮩ ��६����� � �����.
;��室: ASCII-�।�⠢����� ��������� �᫠
;� ���浪�� ᫥������� - ���訩 ���� �� ����襬� �����.
;*****************************************************************************
BCD2ASCII	MACRO	_var, _len
local	M1
	push	ax		;store registers
	push	bx
	push	cx
	push	si
	xor	bx, bx		;bx - ᫥�� ���ࠢ�
	mov	si, _len
	dec	si		;si - right to left
M1:
	mov	al, _var[bx]	;store 1 byte
	mov	ah, _var[si]	;store 1 byte
	add	al, 30h		;convert byte value to ASCII-keycode
	add	ah, 30h		;convert byte value to ASCII-keycode
	mov	_var[si], al	;swap
	mov	_var[bx], ah	;swap
	inc	bx
	dec	si
	cmp	bx, si
	jl	M1
	pop	si		;restore registers
	pop	cx
	pop	bx
	pop	ax
		ENDM
;*****************************************************************************
.model small
.stack 256
.data
mes_1   db      10, 13, 'Enter 8 characters: $'
mes_2	db	10, 13, 'You entered: $'
num     db      8 dup (0)
num_len=$-num
.code
main	proc
	mov	ax, @data
	mov	ds, ax
        
@DispStr mes_1
GetASCII num, num_len
ASCII2BCD num, num_len
BCD2ASCII num, num_len
@DispStr mes_2
PutASCII num, num_len	
exit:
	mov	ax, 4c00h
	int	21h
main	endp
end	main
