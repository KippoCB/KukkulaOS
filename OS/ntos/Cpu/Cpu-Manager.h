//========== Copyright (C) KukkulaOS 2026, All Rights Reserved ==========
//
// File:
//      cpu_manager.h
//
// Purpose:
//      Defines the Task Control Block (TCB) and task states for the
//      core CPU scheduler using the KukkulaOS systemwide types.
//       made by:Samppava    
//=======================================================================

#pragma once     //  Prevents the compiler from accidentally loading this header file more than once, avoiding duplication errors.// 

#include "nttypes.h"


#ifndef CPU_MANAGER_H
#define CPU_MANAGER_H

// Task states used by the scheduler
#define TASK_STATE_READY    0   // Waiting in line to be executed
#define TASK_STATE_RUNNING  1   // Currently holding the CPU core
#define TASK_STATE_BLOCKED  2   // Waiting for an I/O device or timer (sleeping)
#define TASK_STATE_DEAD     3   // Terminated, waiting for memory cleanup


//* task control block representing a thread/process profile*//
struct _TASK {
    LPVOID esp;                 // Stack pointer (Stores saved CPU registers)
    INT pid;                    // Unique Process ID
    INT state;                  // Current status of the task (TASK_STATE_*)
    INT priority;               // Priority level for future expansion
    INT sleep_ticks;            // Countdown timer if the task is sleeping
    struct _TASK* next;         // Pointer to the next task (Circular linked list)
};




// KukkulaOS handle aliases for cleaner kernel development notation
typedef struct _TASK TASK;
typedef struct _TASK* PTASK;

#endif // CPU_MANAGER_H

// tää on varmaan ${asia3} = 1
// kun €[tulos] == 1
// niin (asia1{asia3[€tulos] = 2} = 4) = 7£

// We will use the comment above for later problem solving