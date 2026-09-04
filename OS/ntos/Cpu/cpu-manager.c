//========== Copyright (C) KukkulaOS 2026, All Rights Reserved ==========
//
// File:
//
//      cpu_manager.c
//
// Purpose:
//
//      Implements the core Round-Robin CPU scheduling algorithm and
//      task queue management.
//
// Made by:
//
//      Samppava
//
//=======================================================================

#include "Cpu-Manager.h"


// Global tracking variables

PTASK current_task = 0;
PTASK task_list_head = 0;
INT next_pid = 1;


// Register a newly initialized task


VOID kxregisterTask(PTASK NewTask)
{
    PTASK last_task;

    // Check if the task pointer is valid
    if (NewTask == 0)
    {
        return;
    }

    // Initialize the new task
    NewTask->pid = next_pid++;
    NewTask->state = TASK_STATE_READY;
    NewTask->sleep_ticks = 0;
    NewTask->priority = 0;

    // If this is the first task, initialize the task list
    if (task_list_head == 0)
    {
        task_list_head = NewTask;
        NewTask->next = NewTask;
        current_task = NewTask;

        return;
    }

    // Start searching from the first task
    last_task = task_list_head;

    // Find the last task in the circular task list
    while (last_task->next != task_list_head)
    {
        last_task = last_task->next;
    }

    // Add the new task to the end of the list
    last_task->next = NewTask;
    NewTask->next = task_list_head;
}