//========== Copyright (C) KukkulaOS 2026, All Rights Reserved ==========
//
// File:
//
//      cpu_manager.h
//
// Purpose:
//
//      Defines the Task Control Block (TCB) and task states for the
//      core CPU scheduler using the KukkulaOS systemwide types.
//
// Made by:
//
//      Samppava
//
//=======================================================================

#pragma once

#include "nttypes.h"

#ifndef CPU_MANAGER_H
#define CPU_MANAGER_H


// Task states used by the scheduler

#define TASK_STATE_READY    0
#define TASK_STATE_RUNNING  1
#define TASK_STATE_BLOCKED  2
#define TASK_STATE_DEAD     3


// Task Control Block

typedef struct _TASK
{
    LPVOID esp;                 // Stack pointer
    INT pid;                    // Unique Process ID
    INT state;                  // Current task state
    INT priority;               // Task priority
    INT sleep_ticks;            // Sleep countdown

    struct _TASK *next;         // Next task in circular queue

} TASK, *PTASK;


// Scheduler globals

extern PTASK current_task;
extern PTASK task_list_head;
extern INT next_pid;


// Register a task

VOID kxregisterTask(PTASK NewTask);


#endif // CPU_MANAGER_H