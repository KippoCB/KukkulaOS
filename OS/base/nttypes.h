#ifndef NTTYPES_H
#define NTTYPES_H

//
// Numerical types to represent values like counters or counts.
typedef char CHAR;
typedef unsigned char UCHAR;
typedef short SHORT;
typedef unsigned short USHORT;
typedef int INT;
typedef unsigned int UINT;
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
// NT syscall


#endif // NTTYPES_H