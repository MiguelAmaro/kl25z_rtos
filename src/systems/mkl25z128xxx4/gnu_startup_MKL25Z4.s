.syntax unified
.arch armv6-m
.eabi_attribute Tag_ABI_align_preserved, 1

                .section    stack
                .set        stack_size, 0x00000100
                .balign     8
stack_mem:      .space      stack_size

__initial_sp:
                .section    heap, "aw"
                .set        heap_size, 0x00000000
                .balign     8
__heap_base:
heap_mem:       .space    heap_size
__heap_limit:


                .thumb
                // Vector Table Mapped to Address 0 at Reset
				// suppsosed to be data & readonly
				.section reset
                .global  __Vectors
                .global  __Vectors_End
                .global  __Vectors_Size

__Vectors:       
                .long     __initial_sp                        // Top of Stack
                .long     Reset_Handler                       // Reset Handler
                .long     NMI_Handler                         // NMI Handler
                .long     HardFault_Handler                   // Hard Fault Handler
                .long     0                                   // Reserved
                .long     0                                   // Reserved
                .long     0                                   // Reserved
                .long     0                                   // Reserved
                .long     0                                   // Reserved
                .long     0                                   // Reserved
                .long     0                                   // Reserved
                .long     SVC_Handler                         // SVCall Handler
                .long     0                                   // Reserved
                .long     0                                   // Reserved
                .long     PendSV_Handler                      // PendSV Handler
                .long     SysTick_Handler                     // SysTick Handler

                                                              // External Interrupts
                .long     DMA0_IRQHandler                     // DMA channel 0 transfer complete
                .long     DMA1_IRQHandler                     // DMA channel 1 transfer complete
                .long     DMA2_IRQHandler                     // DMA channel 2 transfer complete
                .long     DMA3_IRQHandler                     // DMA channel 3 transfer complete
                .long     Reserved20_IRQHandler               // Reserved interrupt
                .long     FTFA_IRQHandler                     // Command complete and read collision
                .long     LVD_LVW_IRQHandler                  // Low-voltage detect, low-voltage warning
                .long     LLWU_IRQHandler                     // Low leakage wakeup Unit
                .long     I2C0_IRQHandler                     // I2C0 interrupt
                .long     I2C1_IRQHandler                     // I2C1 interrupt
                .long     SPI0_IRQHandler                     // SPI0 single interrupt vector for all sources
                .long     SPI1_IRQHandler                     // SPI1 single interrupt vector for all sources
                .long     UART0_IRQHandler                    // UART0 status and error
                .long     UART1_IRQHandler                    // UART1 status and error
                .long     UART2_IRQHandler                    // UART2 status and error
                .long     ADC0_IRQHandler                     // ADC0 interrupt
                .long     CMP0_IRQHandler                     // CMP0 interrupt
                .long     TPM0_IRQHandler                     // TPM0 single interrupt vector for all sources
                .long     TPM1_IRQHandler                     // TPM1 single interrupt vector for all sources
                .long     TPM2_IRQHandler                     // TPM2 single interrupt vector for all sources
                .long     RTC_IRQHandler                      // RTC alarm
                .long     RTC_Seconds_IRQHandler              // RTC seconds
                .long     PIT_IRQHandler                      // PIT interrupt
                .long     Reserved39_IRQHandler               // Reserved interrupt
                .long     USB0_IRQHandler                     // USB0 interrupt
                .long     DAC0_IRQHandler                     // DAC0 interrupt
                .long     TSI0_IRQHandler                     // TSI0 interrupt
                .long     MCG_IRQHandler                      // MCG interrupt
                .long     LPTMR0_IRQHandler                   // LPTMR0 interrupt
                .long     Reserved45_IRQHandler               // Reserved interrupt
                .long     PORTA_IRQHandler                    // PORTA Pin detect
                .long     PORTD_IRQHandler                    // PORTD Pin detect
__Vectors_End:

                .set __Vectors_Size,  (__Vectors_End - __Vectors)

// <h> Flash Configuration
//   <i> 16-byte flash configuration field that stores default protection settings (loaded on reset)
//   <i> and security information that allows the MCU to restrict access to the FTFL module.
//   <h> Backdoor Comparison Key
//     <o0>  Backdoor Comparison Key 0.  <0x0-0xFF:2>
//     <o1>  Backdoor Comparison Key 1.  <0x0-0xFF:2>
//     <o2>  Backdoor Comparison Key 2.  <0x0-0xFF:2>
//     <o3>  Backdoor Comparison Key 3.  <0x0-0xFF:2>
//     <o4>  Backdoor Comparison Key 4.  <0x0-0xFF:2>
//     <o5>  Backdoor Comparison Key 5.  <0x0-0xFF:2>
//     <o6>  Backdoor Comparison Key 6.  <0x0-0xFF:2>
//     <o7>  Backdoor Comparison Key 7.  <0x0-0xFF:2>

				.set BackDoorK0, 0xFF
				.set BackDoorK1, 0xFF
				.set BackDoorK2, 0xFF
				.set BackDoorK3, 0xFF
				.set BackDoorK4, 0xFF
				.set BackDoorK5, 0xFF
				.set BackDoorK6, 0xFF
				.set BackDoorK7, 0xFF
//   </h>
//   <h> Program flash protection bytes (FPROT)
//     <i> Each program flash region can be protected from program and erase operation by setting the associated PROT bit.
//     <i> Each bit protects a 1/32 region of the program flash memory.
//     <h> FPROT0
//       <i> Program Flash Region Protect Register 0
//       <i> 1/32 - 8/32 region
//       <o.0>   FPROT0.0
//       <o.1>   FPROT0.1
//       <o.2>   FPROT0.2
//       <o.3>   FPROT0.3
//       <o.4>   FPROT0.4
//       <o.5>   FPROT0.5
//       <o.6>   FPROT0.6
//       <o.7>   FPROT0.7

				.set nFPROT0, 0x00
				.set FPROT0 , (nFPROT0 ^ 0xff)
//     </h>
//     <h> FPROT1
//       <i> Program Flash Region Protect Register 1
//       <i> 9/32 - 16/32 region
//       <o.0>   FPROT1.0
//       <o.1>   FPROT1.1
//       <o.2>   FPROT1.2
//       <o.3>   FPROT1.3
//       <o.4>   FPROT1.4
//       <o.5>   FPROT1.5
//       <o.6>   FPROT1.6
//       <o.7>   FPROT1.7
				.set nFPROT1, 0x00
				.set FPROT1 , (nFPROT1 ^ 0xFF)
//     </h>
//     <h> FPROT2
//       <i> Program Flash Region Protect Register 2
//       <i> 17/32 - 24/32 region
//       <o.0>   FPROT2.0
//       <o.1>   FPROT2.1
//       <o.2>   FPROT2.2
//       <o.3>   FPROT2.3
//       <o.4>   FPROT2.4
//       <o.5>   FPROT2.5
//       <o.6>   FPROT2.6
//       <o.7>   FPROT2.7
				.set nFPROT2, 0x00
				.set FPROT2 , (nFPROT2 ^ 0xFF)
//     </h>
//     <h> FPROT3
//       <i> Program Flash Region Protect Register 3
//       <i> 25/32 - 32/32 region
//       <o.0>   FPROT3.0
//       <o.1>   FPROT3.1
//       <o.2>   FPROT3.2
//       <o.3>   FPROT3.3
//       <o.4>   FPROT3.4
//       <o.5>   FPROT3.5
//       <o.6>   FPROT3.6
//       <o.7>   FPROT3.7
				.set nFPROT3, 0x00
				.set FPROT3 , (nFPROT3 ^ 0xFF)
//     </h>
//   </h>
//   <h> Flash nonvolatile option byte (FOPT)
//     <i> Allows the user to customize the operation of the MCU at boot time.
//     <o.0> LPBOOT0
//       <0=> Core and system clock divider (OUTDIV1) is 0x7 (divide by 8) when LPBOOT1=0 or 0x1 (divide by 2) when LPBOOT1=1.
//       <1=> Core and system clock divider (OUTDIV1) is 0x3 (divide by 4) when LPBOOT1=0 or 0x0 (divide by 1) when LPBOOT1=1.
//     <o.2> NMI_DIS
//       <0=> NMI interrupts are always blocked
//       <1=> NMI_b pin/interrupts reset default to enabled
//     <o.3> RESET_PIN_CFG
//       <0=> RESET pin is disabled following a POR and cannot be enabled as reset function
//       <1=> RESET_b pin is dedicated
//     <o.4> LPBOOT1
//       <0=> Core and system clock divider (OUTDIV1) is 0x7 (divide by 8) when LPBOOT0=0 or 0x3 (divide by 4) when LPBOOT0=1.
//       <1=> Core and system clock divider (OUTDIV1) is 0x1 (divide by 2) when LPBOOT0=0 or 0x0 (divide by 1) when LPBOOT0=1.
//     <o.5> FAST_INIT
//       <0=> Slower initialization
//       <1=> Fast Initialization
				.set FOPT, 0xFF
				
/*				
Flash security byte (FSEC)
WARNING: If SEC field is configured as "MCU security status is secure" and MEEN field is configured as "Mass erase is disabled",
MCU's security status cannot be set back to unsecure state since Mass erase via the debugger is blocked !!!

SEC [0 - 1]
 	2 = MCU security status is unsecure
 	3 = MCU security status is secure

Flash Security
FSLACC [2 - 3]
 	2 = Freescale factory access denied
 	3 = Freescale factory access granted

Freescale Failure Analysis Access Code
   MEEN [4 - 5]
 	2 = Mass erase is disabled
  3 = Mass erase is enabled

   KEYEN [6 - 7]
    2 = Backdoor key access enabled
    3 = Backdoor key access disabled
*/
                 //Backdoor Key Security Enable
				.set FSEC, 0xFE
				
				
				
                .ifndef   RAM_TARGET
                // AREA    |.ARM.__at_0x400|, CODE, READONLY
				.text   
                .byte     BackDoorK0, BackDoorK1, BackDoorK2, BackDoorK3
                .byte     BackDoorK4, BackDoorK5, BackDoorK6, BackDoorK7
                .byte     FPROT0    , FPROT1    , FPROT2    , FPROT3
                .byte     FSEC      , FOPT      , 0xFF      , 0xFF
                .endif


                // AREA    |.text|, CODE, READONLY
				.text
				
                .global Reset_Handler // .gloabl = EXPORT
				.weak   __main        // .weak   = IMPORT
				.weak  SystemInit
                .weak  Reset_Handler
				.type  Reset_Handler, %function
Reset_Handler:
                cpsid   i               // Mask interrupts
                ldr     r0, =SystemInit
                blx     r0
                cpsie   i               // Unmask interrupts
                ldr     r0, =__main
                bx      r0

// Dummy Exception Handlers (infinite loops which can be modified)
                .weak  NMI_Handler
NMI_Handler:
                B       .

HardFault_Handler:
                .weak  HardFault_Handler         
                B       .
                
                .weak  SVC_Handler         
SVC_Handler:                
                B       .
                
                .weak  PendSV_Handler         
PendSV_Handler:                
                B       .
                
.type SysTick_Handler, %function
                
                .weak  SysTick_Handler         
                B       .
                
Default_Handler:
                .global  DMA0_IRQHandler         
                .global  DMA1_IRQHandler         
                .global  DMA2_IRQHandler         
                .global  DMA3_IRQHandler         
                .global  Reserved20_IRQHandler   
                .global  FTFA_IRQHandler         
                .global  LVD_LVW_IRQHandler      
                .global  LLWU_IRQHandler         
                .global  I2C0_IRQHandler         
                .global  I2C1_IRQHandler         
                .global  SPI0_IRQHandler         
                .global  SPI1_IRQHandler         
                .global  UART0_IRQHandler        
                .global  UART1_IRQHandler        
                .global  UART2_IRQHandler        
                .global  ADC0_IRQHandler         
                .global  CMP0_IRQHandler         
                .global  TPM0_IRQHandler         
                .global  TPM1_IRQHandler         
                .global  TPM2_IRQHandler         
                .global  RTC_IRQHandler          
                .global  RTC_Seconds_IRQHandler  
                .global  PIT_IRQHandler          
                .global  Reserved39_IRQHandler   
                .global  USB0_IRQHandler         
                .global  DAC0_IRQHandler         
                .global  TSI0_IRQHandler         
                .global  MCG_IRQHandler          
                .global  LPTMR0_IRQHandler       
                .global  Reserved45_IRQHandler   
                .global  PORTA_IRQHandler        
                .global  PORTD_IRQHandler        
                .global  DefaultISR          

				.macro def_irq_handler handler_name
				.weak \handler_name
				.set  \handler_name, DefaultISR
				.endm
    
				def_irq_handler DMA0_IRQHandler
				def_irq_handler DMA1_IRQHandler
				def_irq_handler DMA2_IRQHandler
				def_irq_handler DMA3_IRQHandler
				def_irq_handler Reserved20_IRQHandler
				def_irq_handler FTFA_IRQHandler
				def_irq_handler LVD_LVW_IRQHandler
				def_irq_handler LLWU_IRQHandler
				def_irq_handler I2C0_IRQHandler
				def_irq_handler I2C1_IRQHandler
				def_irq_handler SPI0_IRQHandler
				def_irq_handler SPI1_IRQHandler
				def_irq_handler UART0_IRQHandler
				def_irq_handler UART1_IRQHandler
				def_irq_handler UART2_IRQHandler
				def_irq_handler ADC0_IRQHandler
				def_irq_handler CMP0_IRQHandler
				def_irq_handler TPM0_IRQHandler
				def_irq_handler TPM1_IRQHandler
				def_irq_handler TPM2_IRQHandler
				def_irq_handler RTC_IRQHandler
				def_irq_handler RTC_Seconds_IRQHandler
				def_irq_handler PIT_IRQHandler
				def_irq_handler Reserved39_IRQHandler
				def_irq_handler USB0_IRQHandler
				def_irq_handler DAC0_IRQHandler
				def_irq_handler TSI0_IRQHandler
				def_irq_handler MCG_IRQHandler
				def_irq_handler LPTMR0_IRQHandler
				def_irq_handler Reserved45_IRQHandler
				def_irq_handler PORTA_IRQHandler
				def_irq_handler PORTD_IRQHandler
DefaultISR:
                ldr    R0, = DefaultISR
                bx     R0
                .align


// User Initial Stack & Heap

                .ifdef   __MICROLIB

                .global  __initial_sp
                .global  __heap_base
                .global  __heap_limit

                .else

                //IMPORT  __use_two_region_memory
                .global  __user_initial_stackheap

__user_initial_stackheap:
                ldr     R0, =   heap_mem
                ldr     R1, = (stack_mem + stack_size)
                ldr     R2, = ( heap_mem +  heap_size)
                ldr     R3, =  stack_mem
                bx      LR

                .align

                .endif


                .end
