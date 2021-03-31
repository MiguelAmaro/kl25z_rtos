#include "MKL25Z4.h"
#include "LAL.h"

#if 0
// Hold resources for specific subsystems
typedef struct { u32 empty; } abstract_proccessor;


typedef struct {
	// Dynamic so initialis in RAM
	struct HouseKeeping{
		// CPU Register Values
		void *StackPoiner;
		u32 programCounter;
	} taskContext;
	// TaskData:
	//TaskStack;
	//Task Work Area - Heap;
} processDescriptor;

typedef struct { //TODO: foward declare this maybe
	u32 id; //NOTE: should this be a function(task) pointer or a unique number
	u8 status;
	u8 priority;
	taskControl* nextTask; //????
	
} taskControl;

// TODO: check typo shceduler
typedef struct {
	/*
	pg29
	Running: (A linked list syle Queue Where the task control block is the node)
	Base level task are always here also pre-empted tasks
	Sorted by priority
	Wating:
	// Tasks that finish 
	*/
	//TODO: Replace (taskContol running, wating) with a linked list of TCBs
	taskControl* running; 
	taskControl* ready[20]; // 
	taskControl* wating[20]; //
    
} schdulerTasks;

void RoundRobinScheduler(void) {
	// FIFO Dispatcher
}
int Executive(void){
	//Handles Scheduling, Mutual exclusion, Data transfer, Synchronozation
}


int Kernal(void) {
	
	
	
}


int CreateTask(void){
	
	
}
#endif

u32 foobar(u32 *i)
{
    *i *= (u32)i;
    
    i++;
    
    u32 j = 0;
    for(; j < 20; j++)
    {
        *i += j;
        j = j * 2;
    }
    
    return j;
}

int main(void)
{
    u32 counter = 0;
    
    for(u32 i = 0; i < 10; i++)
    {
        counter += 20;
    }
    
    u32 jazz = 0;
    u32 fizz = 0;
    while(1)
    {
        jazz = foobar(&counter);
        fizz = jazz + counter;
        
    }
}
