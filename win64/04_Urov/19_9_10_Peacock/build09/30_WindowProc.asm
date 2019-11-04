;-------------------WindowProc-----------------------------------------------
WindowProc proc uses rbx rdi rsi @@hwnd:QWORD, @@mes:QWORD, @@wparam:QWORD, @@lparam:QWORD
	local @@hdc:QWORD,@@hbrush:QWORD,@@hbit:QWORD

;Ensure the Stack is Aligned by 10h
	and rsp,-16

;Store Values retrieved by DispatchMessageA:
	mov @@hwnd,rcx
	mov @@mes,rdx
	mov @@wparam,r8
	mov @@lparam,r9

	cmp rdx,0Fh ;WM_PAINT
		je wmpaint
	cmp rdx,111h ;WM_COMMAND
		je wmcommand
	cmp rdx,1 ;WM_CREATE
		je wmcreate	
	cmp rdx,2 ;WM_DESTROY
		je wmdestroy
	jmp default

wmcreate:
;�������� ���������� �����������, ������������ � ����� ����������

;int GetSystemMetrics(int nIndex) // system metric or configuration setting to retrieve
	Call1 GetSystemMetrics,0 ;SM_CXSCREEN = 0
	mov X_max,rax
	Call1 GetSystemMetrics,1 ;SM_CYSCREEN = 1
	mov Y_max,rax

;�������� �������� ���������� ���� �� ������ @@hdc=GetDC(@@hwnd)
	Call1 GetDC,@@hwnd
	mov @@hdc,rax

;�������� ����������� �������� ���������� ������ 
;memdc=CreateCompatibleDC(@@hdc)
	Call1 CreateCompatibleDC,@@hdc
	mov memdc,rax ;!!! memdc - ���������� ����������

;�������� ���������� ���������� ����������� � ������
;@@hbit=CreateCompatibleBitmap(@@hdc,@@maxX,@@maxY)
	sub rsp,20h
	mov rcx,@@hdc
	mov rdx,X_max
	mov r8,Y_max
	call CreateCompatibleBitmap
	add rsp,20h
	mov @@hbit,rax

;�������� ����� � �������� ������ SelectObject(memdc,@@hbit)
	Call2 SelectObject,memdc,@@hbit

;�������� ��������� ���������� ������ ����� ������

;������� ���������� ����� ����� hbrush=GetStockObject(GRAY_BRUSH)
	Call1 GetStockObject,2 ;GRAY_BRUSH = 2
	mov @@hbrush,rax

;�������� ����� � �������� ������ SelectObject(memdc,@@hbrush)
	Call2 SelectObject,memdc,@@hbrush

;��������� ��������� ������ ����������� ����
	sub rsp,30h
;BOOL PatBlt(HDC hdc, // handle to device context
	mov rcx,memdc
;int nXLeft, // x-coord. of upper-left corner of rect. to be filled
	xor rdx,rdx
;int nYLeft, // y-coord. of upper-left corner of rect. to be filled
	xor r8,r8
;int nWidth, // width of rectangle to be filled
	mov r9,X_max
;int nHeight, // height of rectangle to be filled
	mov rax,Y_max
	mov qword ptr [rsp+20h],rax
;DWORD dwRop) // raster operation code = dest = pattern = PATCOPY
	mov qword ptr [rsp+28h],0F00021h
	call PatBlt
	add rsp,30h

;��������� �������� ���������� ReleaseDC(@@hwnd,@@hdc)
	Call2 ReleaseDC,@@hwnd,@@hdc

;��������� �������� ���� �������� ��������
;BOOL PlaySound(LPCSTR pszSound, HMODULE hmod, DWORD fdwSound)
;SND_SYNC+SND_FILENAME = 0
	Call3 PlaySoundA,offset playFileCreate,0,0 

;���������� �������� 0
	xor rax,rax
	jmp endWndProc

wmpaint:
;������� �������� ����������
;HDC BeginPaint( HWND hwnd, // handle to window LPPAINTSTRUCT lpPaint
;// pointer to structure for paint information);
	Call2 BeginPaint,@@hwnd,offset ps
	mov @@hdc,rax
;��������� ����������� ���� �������� ��������
;SND_SYNC+SND_FILENAME = 0
	Call3 PlaySoundA,offset playFilePaint,0,0 
;������� ������ ������ � ���� BOOL TextOut(  
	sub rsp,30h
;HDC hdc, // handle to device context
	mov rcx,memdc
;int nXStart, // x-coordinate of starting position
	mov rdx,0Ah
;int nYStart, // y-coordinate of starting position
	mov r8,12Ch
;LPCTSTR lpString, // pointer to string
	lea r9,MesWindow
;int cbString // number of characters in string);	
	mov qword ptr[rsp+20h],MesWindowLen
	call TextOutA
	add rsp,30h

;����� ������������ ���� � �������� ����
	sub rsp,50h
;BOOL BitBlt(HDC hdcDest, // handle to destination device context
	mov rcx,@@hdc
;int nXDest,  // x-coordinate of destination rectangle's upper-left corner
	xor rdx,rdx
;int nYDest,  // y-coordinate of destination rectangle's upper-left corner
	xor r8,r8
;int nWidth,  // width of destination rectangle
	mov r9,X_max
;int nHeight, // height of destination rectangle
	mov rax,Y_max
	mov qword ptr [rsp+20h],rax
;HDC hdcSrc,  // handle to source device context
	m64m64 qword ptr [rsp+28h],memdc
;int nXSrc,   // x-coordinate of source rectangle's upper-left corner
	mov qword ptr [rsp+30h],0
;int nYSrc,   // y-coordinate of source rectangle's upper-left corner
	mov qword ptr [rsp+38h],0
;DWORD dwRop)  // raster operation code = dest = source = SRCCOPY
	mov qword ptr [rsp+40h],0CC0020h
	call BitBlt
	add rsp,50h

;���������� �������� BOOL EndPaint(HWND hWnd, // handle to window 
;CONST PAINTSTRUCT *lpPaint // pointer to structure for paint data);
	Call2 EndPaint,@@hwnd,offset ps

;������������ �������� 0
	xor rax,rax
	jmp endWndProc

wmdestroy:
;������� ����������� ���� DeleteDC(memdc)
	Call1 DeleteDC,memdc

;��������� ���������� ������ ���������� �������� ��������
;SND_SYNC+SND_FILENAME = 0
	Call3 PlaySoundA,offset playFileDestroy,0,0 

;������� ��������� WM_QUIT
;������� ����� VOID PostQuitMessage(int nExitCode) // exit code
	Call1 PostQuitMessage,0

;������������ �������� 0
	xor rax,rax
	jmp endWndProc

wmcommand:
;����� ��������� ��������� ��������� �� ����
;MenuProc (DWORD @@hwnd, DWORD @@wparam)
	Call4 MenuProc,@@hwnd,@@wparam,@@hdc,@@hbrush
	jmp endWndProc

default:
;��������� �� ���������
	Call4 DefWindowProc,@@hwnd,@@mes,@@wparam,@@lparam
	;jmp endWndProc
;... ... ...

endWndProc:
	ret

WindowProc endp
