INCLUDE dos.inc
;*****************************************************************************
;����� ��ᨬ���쭮�� ����� �����筮�� �᫠ ��� ��᫥����� �८�ࠧ������
;*****************************************************************************
;�室: ��� ��६�����, �㤠 �㤥� ����饭� ASCII-�।�⠢�����
;���������� �᫠ � ࠧ��୮��� �⮣� �᫠ � �����
;��室: ���祭�� 㪠������ ��६����� � �����
;*****************************************************************************
GetASCII MACRO var, len
local get1
	push	ax		;store registers
	push	bx
	push	cx
        xor     ax, ax
        mov     ah, 1h		;1h int 21h (���� 1 ᨬ���� � ���᮫� � �宬)
        xor     bx, bx
        mov     cx, len        ;�⮫쪮 ࠧ ����ਬ 横�
get1:
        int     21h             ;����砥� ᨬ��� (� al)
        mov     var[bx],al     ;��ࠢ�塞 �� �����
        inc     bx              ;�ਡ���塞 ����
        loop    get1
	pop	cx		;restore registers
	pop	bx
	pop	ax
        ENDM
;*****************************************************************************
;����� �����।�⢥����� �뢮�� �� �࠭ �᫠ � ASCII-�।�⠢�����
;(��� �஡���, ���室� �� ᫥������ ��ப� � ������ ���⪨).
;*****************************************************************************
;�室: ��� ��६�����, ᮤ�ঠ饩 �᫮ � ASCII-�।�⠢�����, � �� ࠧ���.
;��室: ��ப� �� �࠭�.
;*****************************************************************************
PutASCII        MACRO var, len
local M1
	push	ax		;store registers
	push	dx
	push	cx
	push	si
	mov	ah, 2h		;int 21h func 2h
	xor	si, si
        mov     cx, len
M1:
        mov     dl, var[si]
	int	21h
	inc	si
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
GetASCII num, num_len
@DispStr mes_2
PutASCII num, num_len
	
exit:
	mov	ax, 4c00h
	int	21h
main	endp
end	main
