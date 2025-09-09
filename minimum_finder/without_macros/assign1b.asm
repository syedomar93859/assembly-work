// Author: Syed Omar
// Date: Sept 24 2024

// Description:
//      Program with macros that tries to find the minimum of y = 6x^4 - 333x^2 - 74x - 23 in the range -11<=x<=9. 












output_str: .string "x = %d, y = %d, min = %d\n"        // Format string to print an integer with a newlinei
        .balign 4                                               // ensure instructions are divisible by 4 bytes
        .global main                                    // make main visible to linker

main:
        stp x29, x30, [sp, -16]!          // allocate memory and store x29 and x30 on stack (16 bytes)
        mov x29, sp                     // update x29
        mov x19, -11                    // x19 = -11
        mov x28, 0xFFFFFFFE             // 0xFFFFFFFE is the max value
        b pretest1                      // branch to pretest condition of loop
loop1:
        mov x26, 0              // x26 = 0
        mov x27, 6              // x27 = 6
        madd x20, x19, x19, x26           //x20 = x^2 = (x * x) + 0
        madd x20, x20, x20, x26         //x20 = x^4 = (X^2 * x^2) + 0
        madd x20, x20, x27, x26             //x20 = 6x^4 = (x^4 * 6) + 0

        mov x26, 0              // x26 = 0
        mov x27, -333           // x27 = -333
        madd x21, x19, x19, x26           // x21 = x^2 = (x * x) + 0
        madd x21, x21, x27, x26         // x21 = -333x^2 = (x^2 * -333) + 0

        mov x26, 0              // x26 = 0
        mov x27, -74            // x27 = -74
        madd x22, x19, x27, x26        // x22 = -74x = (x * -74) + 0 

        mov x26, 1              // x26 = 1
        mov x27, -23            // x27 = -23
        madd x23, x20, x26, x21           // x23 = (6x^4 * 1) + (-333x^2)
        madd x24, x23, x26, x22           // x24 = (6x^4 - 333x^2) + (-74x)
        madd x25, x24, x26, x27           // x25 = (6x^4 - 333x^2 - 74x) + (-23)

        adrp x0, output_str                             // set 1st arg of printf, high order bits
        add x0, x0, :lo12:output_str                    // set 1st arg of printf, low 12 order bits
        mov x1, x19                                     // set 2nd arg of printf, x1 = x19 = x19
        mov x2, x25                                     // set 3rd arg of printf, x2 = x25 = x25
        cmp x25, x28                                    // compare x25  with x28
        b.lt newmin                                     // enter newmin if x25 < x28                    

        mov x3, x28                                     // set 4th arg of printf, x3 = x28
        bl printf                                       // call printf function
        madd x19, x19, x26, x26                             // x19 = (x19 * 1) + 1
	b pretest1

newmin:
        mov x28, x25                                    // Store new minimum in x28
        mov x3, x28                                     // set 4th arg of printf, x3 = x28
        bl printf                                       // call printf function
        madd x19, x19, x26, x26                              // x19 = x19 + 1
        b pretest1                                      // branch to pretest condition of loop

pretest1:
        cmp x19, 9                                              // compare x19 with 9
        b.le loop1                                              // if x19 <= 9, loop

gdb1: //Breakpoint  
        mov x19, 10				// This line is needed to print out the minimum in gdb
	ldp x29, x30, [sp], 16                  // restore x29 and x30 and deallocate memory from stack        
	ret                                                             // return to caller
                                                                                
