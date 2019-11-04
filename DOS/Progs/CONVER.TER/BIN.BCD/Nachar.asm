INCLUDE minica1.inc		;PutBCD
INCLUDE minica2.inc		;PutASCII
;********************************
;����� �८�ࠧ������ 楫��� ������������ ����筮�� �᫠
;������ �� 2^8 ���� � ��㯠�������� BCD-�।�⠢�����
;********************************
;����: ��� ��६�����, ᮤ�ঠ饩 ��室��� ����筮� �᫮,
;����� �⮩ ��६����� � ����� (!),
;��� ��६�����-���� ��� �࠭���� �ᯠ���������
;��⭠����筮�� �।�⠢����� ��室���� ����筮�� �᫠,
;����� ��६�����-���� � ����� (buf_len = 2 * num_len),
;��� ��६�����, � ������ �㤥� ����饭� BCD-�।�⠢�����
;����� ��६�����-�⢥�
;�����: ���祭�� ��६�����-�⢥� - ��㯠�������� BCD-�᫮
;********************************
Bin2BCD MACRO num, num_len, buf, buf_len, var, var_len
LOCAL HDTB, DBuf, DDigit, CmpBuf0, Over
	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	push	si
;������� ����� �ᯠ����� bin -> BCH
	mov	si, num_len
	mov	di, buf_len
	xor	ax, ax
HDTB:
	dec	si
	dec	di
	mov	al, num[si]	;ax:00D3
	and	ax, 0Fh		;ax:0003
	mov	buf[di], al	;|03|
        dec     di
	mov	al, num[si]	;ax:00D3
	mov	cx, 4
	shr	ax, cl		;ax:000D
	mov	buf[di], al	;|0D|
	cmp	si, 0
	jne	HDTB
;����� �������⭮�� ������� ���� ������ �� ᢥ����� ��� � ���
	xor	di, di		;byte counter in 'var'
DBuf:				;Divide 'buf' by 10
;����� ������������ ������� 楫��� �ᯠ���������
;��⭠����筮�� �᫠ �� ��१�� [0, 2^(2^16)) �� 10
;����஥� �� �ਭ樯� ������� "�⮫�����"
	xor	si, si		;byte counter in 'num'
	xor	ax, ax
	mov	bx, 0A10h
DDigit:				;Divide digit of 'buf' by 10
	mov	al, ah		;ax:0000; ax:0202; ax:0808
	xor	ah, ah		;ax:0000; ax:0002; ax:0008
	mul	bl		;ax:0000; ax:0020; ax:0080
	add	al, buf[si]	;ax:0002 ;ax:0026; ax:0087
	div	bh		;ah:02, al:00 ;ah:08, al: 03
	mov	buf[si], al	;|00|; |03|
	inc	si
	cmp	si, buf_len
	jl	DDigit
	mov	al, ah		;ax:0909
	xor	ah, ah		;ax:0009
	mov	var[di], al	;first digit of result's gotten
	inc	di
;�ࠢ������ 'buf' � �㫥�, �᫨ 'buf' = 0,
;� ����� �����蠥� ࠡ���
	xor	bx, bx
CmpBuf0:
	cmp	bx, buf_len
	je	Over
        cmp     buf[bx], 0      ;�᫨ �஢�७��� ��� ����� 0,
        jg      DBuf            ;� ����� �஢����� �� �㦭�
	inc	bx
        jmp     CmpBuf0         ;�᫨ ࠢ�� ���, ���� �����
Over:
	pop	si
	pop	di
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ENDM
;********************************
.model SMALL
.stack 256
.data
num	db	32 dup (0FFh) 
num_len=$-num
buf	db	2*num_len dup (0)
buf_len=$-buf
var	db	79 dup (0)
var_len=$-var
.code
main proc
	mov	ax, @data
	mov	ds, ax
Bin2BCD num, num_len, buf, buf_len, var, var_len
PutBCD var, var_len
exit:
	mov	ax, 4c00h
	int	21h
main endp
end main
