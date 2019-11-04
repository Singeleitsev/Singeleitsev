	.386
	.model flat, STDCALL

	option casemap:none

;Standard Includes and Libs
	include D:\masm32\include\windows.inc
	include D:\masm32\include\kernel32.inc
	include D:\masm32\include\user32.inc
	include D:\masm32\include\gdi32.inc
	include D:\masm32\include\winmm.inc
	includelib D:\masm32\lib\kernel32.lib
	includelib D:\masm32\lib\user32.lib
	includelib D:\masm32\lib\gdi32.lib
	includelib D:\masm32\lib\winmm.lib
;Custom Includes
	include include\struct32_01.inc

.data
;Handles
	hWnd dd 0
	hInst dd 0
	;hDC dd 0
;Structures
	;lpVersionInformation OSVERSIONINFO <?>
	wcl WNDCLASSEX32 <?>
	message MSG32 <?>
	ps PAINTSTRUCT32 <?>
	szClassName db '���������� Win32',0
	szTitleName db '��������� ���������� Win32 �� ����������',0
	MesWindow db '������! �� ��� ��� ������� ���������� ���������� �� ����������?',0
	MesWindowLen = $-MesWindow-1
	playFileCreate db 'create.wav',0
	playFilePaint db 'paint.wav',0
	playFileDestroy db 'destroy.wav',0
.code
;����� ����� � ���������:
start proc
;������ ���������� ���� 
;	push offset lpVersionInformation
;	call GetVersionExA
;����� ����� �������� ��� ��� ������� ���������� � ������ Windows (���������� 11)
;�������� ��������� �� ��������� ������
;	call GetCommandLineA ;� �������� eax �����
;(��������� � �������� ���)
;�������� ��������� �� ���� � ����������� ���������
;	call GetEnvironmentStringsA ;� �������� eax ����� (��������� � �������� ���)
;��������� �� ��������� STARTUPINFO
;	push offset lpStartupInfo
;	call GetStartupInfoA	
;(��������� � �������� ���)

;�������� �������� �������� ������, �� �������� �������� ������
	push 0
	call GetModuleHandleA 
	mov hInst,eax
;����� hInst ����� �������������� � �������� ����������� ������� ����������
;����� ���������� ����

;-------------------WinMain-------------------
WinMain:

;���������� ����� ����
;��� ������ �������������� ���� ��������� WndClassEx
	mov wcl.cbSize,dword ptr sizeof WNDCLASSEX32 ;������ ���������
	mov wcl.style, 3 ;CS_HREDRAW+CS_VREDRAW
	mov wcl.lpfnWndProc,offset WindowProc ;����� ������� ���������
	mov wcl.cbClsExtra,0
	mov wcl.cbWndExtra,0
	mov eax,hInst
;���������� ���������� � ���� hInstance ��������� wcl
	mov wcl.hInstance,eax
;������� ����� HICON LoadIcon (HINSTANCE hInstance,LPCTSTR lpIconName)
	push 7F00h ;IDI_APPLICATION
	push 0
	call LoadIconA
	mov wcl.hIcon,eax ;���������� ������ � ���� hIcon ��������� wcl
;������� ����� HCURSOR LoadCursorA (HINSTANCE hInstance,LPCTSTR lpCursorName)
	push 7F00h ;IDC_ARROW
	push 0
	call LoadCursorA
	mov wcl.hCursor,eax ;���������� ������� � ���� hCursor ��������� wcl
;��������� ���� ���� ���� - �����
;������� ����� HGDIOBJ GetStockObject(int fnObject)	;type of stock object
	push 0 ;WHITE_BRUSH
	call GetStockObject
	mov wcl.hbrBackground,eax
	mov wcl.lpszMenuName,0 ;��� �������� ����
;��� ������ ����
	mov eax,offset szClassName
	mov wcl.lpszClassName,eax
	mov wcl.hIconSm,0
;������������ ����� ���� - ������� ����� RegisterClassExA (&wndclass)
	push offset wcl
	call RegisterClassExA
	test ax,ax ;��������� �� ����� ����������� ������ ����
	jz end_cycl_msg ;�������

;������� ����:
	push 0 ;lpParam
	push hInst ;hInstance
	push 0 ;menu
	push 0 ;parent hwnd
	push 80000000h ;CW_USEDEFAULT ;������ ����
 	push 80000000h ;CW_USEDEFAULT ;������ ����
	push 80000000h ;CW_USEDEFAULT ;���������� y ������ �������� ����
	push 80000000h ;CW_USEDEFAULT ;���������� x ������ �������� ����
	push 0CF0000h ;WS_OVERLAPPEDWINDOW ;����� ����
	push offset szTitleName ;������ ��������� ����
	push offset szClassName ;��� ������ ����
	push 0
	call CreateWindowExA
	mov hWnd,eax ;hwnd - ���������� ����

;�������� ����:
	push 1 ;SW_SHOWNORMAL
	push hWnd
	call ShowWindow
;�������������� ���������� ����
	push hWnd
	call UpdateWindow

;��������� ���� ���������:
cycl_msg:
	push 0
	push 0
	push 0
	push offset message
	call GetMessageA
	cmp ax,0
	je end_cycl_msg
;���������� ����� � ����������
	push offset message
	call TranslateMessage
;�������� ��������� ������� ���������
	push offset message
	call DispatchMessageA
	jmp cycl_msg

;����� �� ����������
end_cycl_msg:
	push 0
	call ExitProcess
start endp

;-------------------WindowProc-------------------
WindowProc proc uses ebx edi esi, @@hwnd:DWORD, @@mes:DWORD, @@wparam:DWORD, @@lparam:DWORD

	local @@hdc:DWORD

	cmp @@mes,2 ;WM_DESTROY
		je wmdestroy
	cmp @@mes,1 ;WM_CREATE
		je wmcreate
	cmp @@mes,0Fh ;WM_PAINT
		je wmpaint
	jmp default

wmcreate:
;��������� �������� ���� �������� ��������
	push 0 ;SND_SYNC+SND_FILENAME 
	push 0
	push offset playFileCreate
	call PlaySoundA
	mov eax,0 ;������������ �������� 0
	jmp exit_wndproc

wmpaint:
	push 0 ;SND_SYNC+SND_FILENAME 
	push 0
	push offset playFilePaint
	call PlaySoundA
;������� �������� ����������
	push offset ps
	push @@hwnd
	call BeginPaint
	mov @@hdc,eax
;������� ������ ������ � ����
	push MesWindowLen	
	push offset MesWindow
	push 0A0h
	push 0Ah
	push @@hdc
	call TextOutA
;���������� ��������
	push offset ps
	push @@hdc
	call EndPaint
	mov eax,0 ;������������ �������� 0
	jmp exit_wndproc

wmdestroy:
	push 0;SND_SYNC+SND_FILENAME 
	push 0
	push offset playFileDestroy
	call PlaySoundA
;������� ��������� WM_QUIT
	push 0
	call PostQuitMessage
	mov eax,0 ;������������ �������� 0
	jmp exit_wndproc

;��������� �� ���������
default:
	push @@lparam
	push @@wparam
	push @@mes
	push @@hwnd
	call DefWindowProcA
	jmp exit_wndproc

exit_wndproc:
	ret
WindowProc endp
end start

