//========== Copyright (C) KukkulaOS 2026, All Rights Reserved ==========
//
// File:
//      nttypes.h
//
// Purpose:
//      Contains the basic datatypes used systemwide. Also contains the
//      standard kernel function calling convention using __stdcall
//
// Edits:
//       KippoCB
//             * Create | 3.9.2026
//
//=======================================================================
#ifndef NTTYPES_H
#define NTTYPES_H

//
// Numerical types to represent values like counters or counts.
//
// LONG is 32bits as windows has a 32 bit long and 64bit long long int
typedef char CHAR;
typedef unsigned char UCHAR;
typedef short SHORT;
typedef unsigned short USHORT;
typedef int INT;
typedef unsigned int UINT;
typedef int LONG;
typedef unsigned int ULONG;
typedef long long int LONGLONG;
typedef unsigned long long int ULONGLONG;

//
// Abstract values
typedef unsigned char BYTE;
typedef unsigned short WORD;
typedef unsigned int DWORD;
typedef unsigned long long int QWORD;

//
// String types
typedef char* LPSTR;
typedef const char* LPCSTR;

//
// Truth values
typedef int BOOL;
#define TRUE 1
#define FALSE 0

//
// Void and long pointer to void
typedef void VOID;
typedef void* LPVOID;

//
// NT status code. This code will be returned from the operations we can do during the system's runtime
typedef LONG NTSTATUS;

//
// Standard NT calling convention for kernel functions
//
// This will push the arguments of an function from right to left to the stack(so VOID NTAPI foo(BYTE a, BYTE b, BYTE c) will be stored in the order c -> b -> a)
// The compiler will also alter the name of the function in the final combined code to _foo(a, b, c)@6
#define NTAPI __attribute__((stdcall))

#endif // NTTYPES_H