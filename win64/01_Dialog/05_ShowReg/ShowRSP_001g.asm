include D:\bin\dev\ml64\VS2015\include\user32.inc
include D:\bin\dev\ml64\VS2015\include\kernel32.inc

includelib D:\bin\dev\ml64\VS2017\lib\user32.lib
includelib D:\bin\dev\ml64\VS2017\lib\kernel32.lib

include D:\hob\dev\asm\x64\include\Spell_06.inc

.const
szCaption db "I've got the power!", 0

.data
szTextStack db "������� �����: 0000.0000.0000.0000h",0
szText db "MessageBoxA was called",0

.code

WinMain proc
sub rsp, 28h

mov rax, rsp
Spell64rax 0, szCaption, szTextStack

xor rcx, rcx		;hWnd = HWND_DESKTOP = 0
lea rdx, szText		;lpText
lea r8, szCaption	;lpCaption
xor r9, r9		;uType = MB_OK = 0
call MessageBoxA

mov rax, rsp
Spell64rax 0, szCaption, szTextStack

xor rcx, rcx		;hWnd = HWND_DESKTOP = 0
lea rdx, szText		;lpText
lea r8, szCaption	;lpCaption
xor r9, r9		;uType = MB_OK = 0
call MessageBoxA

mov rcx, 4
@@:
mov rax, rsp
Spell64rax 0, szCaption, szTextStack
dec cx
cmp cx, 0
jg @b

add rsp, 20h
xor rcx, rcx
call ExitProcess
WinMain endp
end