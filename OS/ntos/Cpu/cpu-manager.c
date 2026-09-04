//========== Copyright (C) KukkulaOS 2026, All Rights Reserved ==========
//
// File:
//      cpu_manager.c
//
// Purpose:
//      Implements the core Round-Robin CPU scheduling algorithm and
//      task queue management.
//
// Made by:
//       Samppava    
//=======================================================================




#include "Cpu-Manager.h"


//* global tracking variables for the CPU subsystem//*

PTASK current_task = 0;       // Pointer to the currently executing task
PTASK task_list_head = 0;     // Root node of the circular ready queue
INT next_pid = 1;             // Monotonically increasing Process ID counter

// Registers a newly initialized task profile into the execution queue


VOID NTAPI kxregisterTask(PTASK NewTask) {
    NewTask->pid = next_pid++;
    NewTask->state = TASK_STATE_READY;
    NewTask-> sleep_ticks = 0;
    NewTask->next = 0;

}


 // If the queue is empty, establish this task as the base loop

if (task_list_head == 0) {
    task_list_head = NewTask;
    NewTask->next = NewTask;  // Point to itself to close the circular chain

}







