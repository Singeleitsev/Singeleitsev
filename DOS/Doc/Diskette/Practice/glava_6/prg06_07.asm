;----------------------------------------------------------
;prg06_07.asm - ���� � ������� ����������� ����� �� ��������� 0..99 � �������� ��� ����� �� �������.
;----------------------------------------------------------
masm
model small
.stack	256
.486
buf_0ah	struc
len_buf	db	3	;����� buf_0ah
len_in	db	0	;�������������� ����� ���������� ����� (��� ����� 0dh)
buf_in	db	3 dup (20h)	;����� ��� ����� (� ������ 0dh)
ends
.data
buf	buf_0ah	<>
adr_buf	dd	buf
.code
main:
	mov	ax,@data
	mov	ds,ax
;������ 2 ������� � ����������, �������� �� ���������� �������� �� ������
	lds	dx,adr_buf
	mov	ah,0ah
	int	21h
	xor	ax,ax
	cmp	buf.len_in,2	;������� ����� ������� �������?
	jne	m1
	mov	ah,buf.buf_in
m1:
	mov	al,buf.buf_in+1
	and	ax,0f0fh	;�������������� � ������������� ���������� �������������
	aad	;� AL �������� ���������� ��������� ����������� ����������� ��������
;����� �� ������� ����������� AL
	aam
	mov	dx,ax
	or	dx,03030h
	rol	dx,8	;������� ������� �����
	mov	ah,2
	int	21h
	rol	dx,8	;������� ������� �����
	int	21h
exit:
;����� �� ���������
	mov	ax,4c00h	;��������� 4c00h � ������� ax
	int	21h	;����� ���������� � ������� 21h
end	main		;����� ��������� � ������ ����� main