.386
.model	flat, stdcall
option	casemap :none

include \masm32\include\windows.inc

include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib


.data?
hFile		dd ?
hFileMap	dd ?
lpMem		dd ?
nBytes		dd ?
dwWritten	dd ?

.data
szFile		db "license.",0
szObjName  	db "dedicated to KL",0

result		db 050h dup (?)

.code
start:

invoke	CreateFile, offset szFile, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
cmp	eax, -1
je	err
mov	hFile,eax
invoke	CreateFileMapping, hFile, 0, PAGE_READONLY, 0, 0, offset szObjName
or	eax,eax
jz	err
mov	hFileMap,eax
invoke	MapViewOfFile, hFileMap, FILE_MAP_READ, 0, 0, 0
or	eax, eax
jz	err
mov	lpMem, eax

mov	ebx, lpMem
xor	edx, edx

mov	eax, dword ptr ds:[ebx+0b4h]
div	dword ptr ds:[ebx+2ch]
mov	esi, eax
mov	cl, byte ptr ds:[ebx+2ch]
xor	eax, eax
again:
mov	dl, byte ptr ds:[eax+ebx+1d0h]
sub	dl, cl
mov	byte ptr [result+eax], dl
inc	eax
dec	esi
jnz short again

invoke	GetStdHandle, -11
mov	ebx, eax
invoke	lstrlen, offset result
mov	edx, eax
invoke	WriteFile, ebx, offset result, edx, addr dwWritten, NULL
err:
invoke	ExitProcess, 0
end start