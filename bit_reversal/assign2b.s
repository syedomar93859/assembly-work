								// File: assign2b.s
								// Authors: Syed Omar
								// Date: Oct 3 2024
								// Description:  Does bit reversal using shift and bitwise logical operations with the original variable to get the reversed variable 

variables: .string "Original: 0x%08X, Reversed: 0x%08X\n"	// Format string to print an integer with a newline
        .balign 4                                       	// ensure instructions are divisible by 4 bytes
        .global main                                    	// make main visible to linker

main:
        stp x29, x30, [sp, -16]!          			// allocate memory and store x29 and x30 on stack (16 bytes)
        mov x29, sp                     			// update x29
        mov w19, 0x7F807F80             			// Initialize variable

        							// Reverse bits in the variable
        							// Step 1       
        mov w20, 0x55555555     				// Store 0x55555555 in w20
        and w21, w19, w20       				// x & 0x55555555
        lsl w21, w21, 1         				// t1 = w21 << 1

        lsr w22, w19, 1         				// w19 >> 1 
        and w22, w22, w20       				// t2 = w22 & 0x55555555 

        orr w22, w22, w21       				// y = t1 | t2

        							// Step 2
        mov w20, 0x33333333     				// Store 0x33333333 in w20
        and w21, w22, w20       				// y & 0x33333333
        lsl w21, w21, 2         				// t1 = w21 >> 2

        lsr w22, w22, 2         				// w22 = y >> 2 
        and w22, w22, w20       				// t2 = w22 & 0x33333333 

        orr w22, w22, w21       				// y = t1 | t2

        							// Step 3
        mov w20, 0x0F0f0f0f     				// Store 0xF0F0F0F0 in w20
        and w21, w22, w20       				// w22 = w22 & w20
        lsl w21, w21, 4         				// t1 = w22 << 4

        lsr w22, w22, 4         				// w22 = w22 >> 4
        and w22, w22, w20       				// t2 = w22 & & w20 

        orr w22, w22, w21       				// y = t1 | t2

        							// Step 4
        mov w23, 0xFF00         				// Store 0xFF00 in w23

        lsl w24, w22, 24        				// t1 = y << 24 

        and w25, w22, w23       				// w25 = y & 0xFF00
        lsl w25, w25, 8         				// t2 = w25 << 8

        lsr w26, w22, 8         				// w26 = y >> 8
        and w26, w26, w23       				// t3 = w26 & 0xFF00

        lsr w27, w22, 24        				// t4 = y >> 24

        orr w25, w25, w24       				// w25 = t1 | t2
        orr w26, w26, w25       				// w26 = w25 | t3
        orr w27, w27, w26       				// w27 = w26 | t4

        ldr x0, = variables     				// 1st argument
        mov w1, w19             				// 2nd arg
        mov w2, w27             				// 3rd arg
        bl printf               				// call printf function

        mov w0, 0               				// Return 0 from main
        ldp x29, x30, [sp], 16  				// Restore frame pointer and line register
        ret                     				// return to caller