;advapi32.inc



;gdi32.inc
BitBlt PROTO :QWORD,:QWORD,:QWORD,:QWORD,:QWORD,:QWORD,:QWORD,:QWORD,:QWORD
CreateCompatibleBitmap PROTO :QWORD,:QWORD,:QWORD
CreateCompatibleDC PROTO :QWORD
CreateSolidBrush PROTO :QWORD
DeleteDC PROTO :QWORD
DeleteObject PROTO :QWORD
LineTo PROTO :QWORD,:QWORD,:QWORD
MoveToEx PROTO :QWORD,:QWORD,:QWORD,:QWORD
PatBlt PROTO :QWORD,:QWORD,:QWORD,:QWORD,:QWORD,:QWORD
Rectangle PROTO :QWORD,:QWORD,:QWORD,:QWORD,:QWORD
SelectObject PROTO :QWORD,:QWORD
SetTextColor PROTO :QWORD,:QWORD
SetPixel PROTO :QWORD,:QWORD,:QWORD,:QWORD
TextOutA PROTO :QWORD,:QWORD,:QWORD,:QWORD,:QWORD



;kernel32.inc
FatalExit PROTO :QWORD
GetCommandLineA PROTO
GetEnvironmentStringsA PROTO
GetLastError PROTO
GetModuleHandleA PROTO :QWORD
GetProcessHeap PROTO
GetStartupInfoA PROTO :QWORD
GetStockObject PROTO :QWORD
GetVersionExA PROTO :QWORD
HeapAlloc PROTO :QWORD,:QWORD,:QWORD
HeapFree PROTO :QWORD,:QWORD,:QWORD



;NtosKrnl.lib
;RtlAllocateHeap PROTO :QWORD,:QWORD,:QWORD



;user32.inc
BeginPaint PROTO :QWORD,:QWORD
CheckMenuItem PROTO :QWORD,:QWORD,:QWORD
CreateWindowExA PROTO :QWORD,:QWORD,:QWORD,:QWORD,:QWORD,:QWORD,:QWORD,:QWORD,:QWORD,:QWORD,:QWORD,:QWORD
DefFrameProcA PROTO :QWORD,:QWORD,:QWORD,:QWORD,:QWORD
DefMDIChildProcA PROTO :QWORD,:QWORD,:QWORD,:QWORD
DefWindowProcA PROTO :QWORD,:QWORD,:QWORD,:QWORD
DestroyMenu PROTO :QWORD
DialogBoxParamA PROTO :QWORD,:QWORD,:QWORD,:QWORD,:QWORD
DispatchMessageA PROTO :QWORD
DrawMenuBar PROTO :QWORD
DrawTextA PROTO :QWORD,:QWORD,:QWORD,:QWORD,:QWORD
EndDialog PROTO :QWORD,:QWORD
EndPaint PROTO :QWORD,:QWORD
EnumChildWindows PROTO :QWORD,:QWORD,:QWORD
GetClientRect PROTO :QWORD,:QWORD
GetDC PROTO :QWORD
GetDlgItemTextA PROTO :QWORD,:QWORD,:QWORD,:QWORD
GetMenu PROTO :QWORD
GetMessageA PROTO :QWORD,:QWORD,:QWORD,:QWORD
GetParent PROTO :QWORD
GetSubMenu PROTO :QWORD,:QWORD
GetSystemMetrics PROTO :QWORD
GetWindow PROTO :QWORD,:QWORD
GetWindowLongPtrA PROTO :QWORD,:QWORD
InvalidateRect PROTO :QWORD,:QWORD,:QWORD
IsWindow PROTO :QWORD
KillTimer PROTO :QWORD,:QWORD
LoadAcceleratorsA PROTO :QWORD,:QWORD
LoadCursorA PROTO :QWORD,:QWORD
LoadIconA PROTO :QWORD,:QWORD
LoadMenuA PROTO :QWORD,:QWORD
MessageBoxA PROTO :QWORD,:QWORD,:QWORD,:QWORD
PostQuitMessage PROTO :QWORD
RegisterClassExA PROTO :QWORD
ReleaseDC PROTO :QWORD,:QWORD
SendMessageA PROTO :QWORD,:QWORD,:QWORD,:QWORD
SetTimer PROTO :QWORD,:QWORD,:QWORD,:QWORD
SetWindowLongPtrA PROTO :QWORD,:QWORD,:QWORD
ShowWindow PROTO :QWORD,:QWORD
TranslateAccelerator PROTO :QWORD,:QWORD,:QWORD
TranslateMDISysAccel PROTO :QWORD,:QWORD
TranslateMessage PROTO :QWORD
UpdateWindow PROTO :QWORD



;winmm.inc
PlaySoundA PROTO :QWORD,:QWORD,:QWORD
