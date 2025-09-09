// Authors: Syed Omar
// Date: Sept 24 2024

// Description:
//      This program finds the minimum of y = 6x^4 - 333x^2 - 74x - 23 in the range -11<=x<=9.

output_str: .string "x = %d, y = %d, min = %d\n"  	// Format string to print an integer with a newline
	.balign 4					// ensure instructions are divisible by 4 bytes
	.global main					// make main visible to linker

main:
	stp x29, x30, [sp, -16]!	// allocate memory and store fp and lr on stack (16 bytes)
	mov x29, sp			// update fp
	mov x19, -11			// This is the lower bound of the range and the smallest x value throughout all the loops: x19 = 0, i = 0
        mov x20, 0xFFFFFFFE		// 0xFFFFFFFE is the max value

pretest1:
	cmp x19, 9	// compare x19 with 9
	b.le loop1	// enter loop1 if x19 <= 9
	b exitloop1	// otherwise exit loop

loop1:
gdb1:    // Breakpoint 1
        mov x21, x19		//Getting current x value
        mul x21, x21, x21	// x * x = x^2
        mul x21, x21, x19	// x^2 * x = x^3
        mul x21, x21, x19	// x^3 * x = x^4
        mov x22, 6		// x22 = 6
        mul x23, x21, x22	// x^4 * 6 = 6x^4
gdb2:    // Breakpoint 2
        mul x24, x19, x19	//x * x = x^2
        mov x25, 333		// x25 = 333
        mul x26, x24, x25	// x^2 * 333 = 333x^2
gdb3:    // Breakpoint 3
        mov x29, 74		// x29 = 74
        mul x27, x19, x29	// x * 74 = 74x
gdb4:    // Breakpoint 4	
       sub x28, x23, x26	//6x^4 - 333x^2 = x28 
       sub x28, x28, x27	//x27 = 74x, x28 = 6x^4 - 333x^2 - 74x
       sub x28, x28, 23		//x28 = 6x^4 - 333x^2 - 74x - 23
gdb5:    // Breakpoint 5

	// set arguments of printf before calling
	ldr x0, =output_str				// set 1st arg of printf
	mov x1, x19					// set 2nd arg of printf, x1 = x19
        mov x2, x28					// set 3rd arg of printf, x2 = x28
        cmp x28, x20					// compare x28 with x20
        b.lt newmin					// enter newmin if x28 < x20			
	mov x3, x20					// set 4th arg of printf, x3 = x20
        bl printf                                       // call printf function
	add x19, x19, 1                                 // x19 = x19 + 1
        b pretest1  					// Go back to pretest1

newmin:
        mov x20, x28        				// Store new minimum in x20
	mov x3, x20					// set 4th arg of printf, x3 = x20
        bl printf					// call printf function
	add x19, x19, 1					// x19 = x19 + 1
	b pretest1					// branch to pretest condition of loop
exitloop1:
	ldp x29, x30, [sp], 16			// restore fp and lr and deallocate memory from stack
	ret								// return to caller