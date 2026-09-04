//========== Copyright (C) KukkulaOS 2026, All Rights Reserved ==========
//
// File:
//      hal.h
//
// Purpose:
//      Contains the HAL interface the kernel sees. It will handle the
//      low level hardware operations specific to different processors
//      and processor architectures. The kernel only sees what hal.dll 
//      and hal.h expose but it will never have to interact with the 
//      actual hardware underneath.
//
// Edits:
//       KippoCB
//             * Create | 3.9.2026
//
//=======================================================================
#ifndef HAL_H
#define HAL_H

#include <nttypes.h>

//
// Routine to read a BYTE from a port
BYTE NTAPI hal_readPortByte(WORD port);

//
// Routine to write a BYTE to a port
VOID NTAPI hal_writePortByte(WORD port, BYTE value);

//
// Routine to disable interrupts
VOID NTAPI hal_disableInterrupts();

//
// Routine to enable interrupts
VOID NTAPI hal_enableInterrupts();

#endif // HAL_H