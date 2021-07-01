#include "MKL25Z4.h"
#include "LAL.h"

// Hold resources for specific subsystems WTfFFFFF
typedef struct { u32 empty; } abstract_proccessor;

typedef struct 
{
    // CPU Register Values
    void *stack_pointer;
    void *program_counter;
} task_context;

typedef struct 
{
    void *task_data;
	void *task_stack;
	void *task_work_area; // Heap?? da fuck is this about
} process_descriptor;

typedef struct 
{ 
	u32 id; //NOTE: should this be a function(task) pointer or a unique number
	u8 status;
	u8 priority;
	//task_control_block* nextTask; //????
} task_control_block;

// TODO: check typo shceduler
/*
	pg29
	Running: (A linked list syle Queue Where the task control block is the node)
	 Implement a priority queue!!!
Wating:
	// Tasks that finish. da fuck do i do here33333
	*/
typedef struct 
{
	//TODO: Replace (taskContol running, wating) with a linked list of TCBs
	task_control_block *running; 
	task_control_block *ready  ;
	task_control_block *wating ;
} scheduler;

void RoundRobinScheduler(void) 
{
    // FIFO Dispatcher
}
void Executive(void)
{
    //Handles Scheduling, Mutual exclusion, Data transfer, Synchronozation
    return; 
}


void Kernal(void)
{
    return; 
}


void CreateTask(void)
{
    return;
}

// Freedom KL25Z LEDs
#define RED_LED_POS   (18)  // on port B
#define GREEN_LED_POS (19)  // on port B
#define BLUE_LED_POS  (1)   // on port D

#define MASK(x) (1UL << (x))


void init_leds(void) {
    // Enable clock to ports B and D
    SIM->SCGC5 |= SIM_SCGC5_PORTB_MASK | SIM_SCGC5_PORTD_MASK;;
    
    // Make 3 pins GPIO
    PORTB->PCR[  RED_LED_POS] &= ~PORT_PCR_MUX_MASK;          
    PORTB->PCR[  RED_LED_POS] |=  PORT_PCR_MUX(1)  ;          
    PORTB->PCR[GREEN_LED_POS] &= ~PORT_PCR_MUX_MASK;          
    PORTB->PCR[GREEN_LED_POS] |=  PORT_PCR_MUX(1)  ;          
    PORTD->PCR[ BLUE_LED_POS] &= ~PORT_PCR_MUX_MASK;          
    PORTD->PCR[ BLUE_LED_POS] |=  PORT_PCR_MUX(1)  ;          
    
    // Set ports to outputs
    PTB->PDDR |= MASK(  RED_LED_POS) | MASK(GREEN_LED_POS);
    PTD->PDDR |= MASK( BLUE_LED_POS)                      ;
    
    // Set pins to low aka LEDs are off on initialization
    PTB->PSOR |= MASK( RED_LED_POS) | MASK(GREEN_LED_POS);
    PTD->PSOR |= MASK(BLUE_LED_POS)                      ;
    
    return;
}

void blue_led_on (void)
{ 
    PTD->PCOR = MASK(  BLUE_LED_POS); 
    
    return; 
}

void blue_led_off(void)
{
    PTD->PSOR = MASK(  BLUE_LED_POS);
    
    return; 
}

void green_led_on (void)
{ 
    PTB->PCOR = MASK(  GREEN_LED_POS); 
    
    return;
}

void green_led_off(void)
{
    PTB->PSOR = MASK(  GREEN_LED_POS); 
    
    return; 
}

int main(void)
{
    init_leds();
    
    
    //~ MAIN LOOP
    while(1)
    {
        green_led_on();
        for(u32 i = 0; i < 20000000; i++);
        
        green_led_off();
        blue_led_on();
        for(u32 i = 0; i < 20000000; i++);
        
        blue_led_off();
    }
    
    
}
