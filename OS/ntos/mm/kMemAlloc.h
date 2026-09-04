//========== Copyright (C) KukkulaOS 2026, All Rights Reserved ==========
//
// File:
//      kMemAlloc.h
//
// Purpose:
//      Contains the routines to allocate physical memory with the kernel
//
// Edits:
//       KippoCB
//             * Create | 3.9.2026
//
//=======================================================================
#ifndef KMEMALLOC_H
#define KMEMALLOC_H

#include <nttypes.h>

//
// This routine will allocate a specified amount of physical memory
VOID mmAllocPhysMemory(IN SIZE_T numberOfBytes, IN OUT PPHYSICAL_ADRESS memAddress);

#endif // KMEMALLOC_H