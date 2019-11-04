INCLUDE dos.inc
;*****************************************************************************
;����� ��ᨬ���쭮�� ����� �����筮�� �᫠
;� �८�ࠧ������ ��� � ��㯠�������� BCD-�᫮
;*****************************************************************************
;����: ��� ��६�����, �㤠 �㤥� ����饭� BCD-�।�⠢�����
;���������� �᫠ � ࠧ��୮��� �⮣� �᫠ � �����
;�����: ���祭�� 㪠������ ��६����� � �����
;���冷� ᫥������� ���� - ����訩 ���� �� ����襬� ����� (Intel)
;*****************************************************************************
GetBCD MACRO _var, _len
local get1
	push	ax		;store registers
	push	bx
	push	cx
        xor     ax, ax
        mov     ah, 1h		;1h int 21h (���� 1 ᨬ���� � ���᮫� � �宬)
        mov     bx, _len
        dec	bx
        mov     cx, _len		;�⮫쪮 ࠧ ����ਬ 横�
get1:
        int     21h             ;����砥� ᨬ��� (� al)
        sub     al, 30h         ;�८�ࠧ㥬 � BCD
        mov     _var[bx],al	;��ࠢ�塞 �� �����
        dec     bx              ;�ਡ���塞 ����
        loop    get1
	pop	cx		;store registers
	pop	bx
	pop	ax
        ENDM
;*****************************************************************************
;����� �����।�⢥����� �뢮�� �� �࠭ ASCII-�।�⠢�����
;��������� ��㯠��������� BCD-�᫠
;(��� �஡���, ���室� �� ᫥������ ��ப� � ������ ���⪨).
;!!!���� ��६����� �� �⮬ ������� ��������� �� ���௥����,
;� ���� �� ����� �㤥� ����஢��� � ���쭥�襬 �� 室� �ணࠬ��!!!
;*****************************************************************************
;�室: ��६�����, ᮤ�ঠ�� ��㯠�������� BCD-�᫮, � �� ࠧ��୮���.
;��室: ASCII-�।�⠢����� ���祭�� �������� ��६����� �� �࠭�
;*****************************************************************************
PutBCD	MACRO _var, _len
local M1
	push	ax		;store registers
	push	dx
	push	cx
	push	si
	mov	ah, 2h		;int 21h func 2h
	mov	si, _len
	dec	si
	mov	cx, _len
M1:
	mov	dl, _var[si]
	add	dl, 30h		;convert to ASCII
	int	21h
	dec	si
	loop	M1
	pop	si		;restore registers
	pop	cx
	pop	dx
	pop	ax
	ENDM
;*****************************************************************************
.model small
.stack 256
.data
mes_1   db      10, 13, 'Enter 8 characters: $'
mes_2	db	10, 13, 'You entered: $'
num     db      8 dup (0)
num_len	equ	$-num
.code
main	proc
	mov	ax, @data
	mov	ds, ax

@DispStr mes_1
GetBCD num, num_len
@DispStr mes_2
PutBCD num, num_len
	
exit:
	mov	ax, 4c00h
	int	21h
main	endp
end	main