/* 
 * Data Project
 * 
 * <Please put your name and login here>
 * 
 * bits.c - Source file with your solutions to the Project.
 *          This is the file you will hand in.
 *
 * WARNING: Do not include the <stdio.h> header; it confuses the dpc
 * compiler. You can still use printf() for debugging without including
 * <stdio.h>, although you might get a compiler warning. In general,
 * it's not good practice to ignore compiler warnings, but in this
 * case it's OK.  
 */

#if 0
/*
 * Instructions to Students:
 *
 * STEP 1: Read the following instructions carefully.
 */

You will provide your solution to the Data Project by
editing the collection of functions in this source file.

INTEGER CODING RULES:
 
	Complete the body of each function with one
	or more lines of C code that implements the function. Your code 
	must consist of a sequence of variable declarations, followed by
	a sequence of assignment statements, followed by a return statement.
  
	The general style is as follows:

	int funct(...) {
		/* brief description of how your implementation works */
		int var1 = expr1;
		...
		int varM = exprM;

		varJ = exprJ;
		...
		varN = exprN;

		return exprR;
	}

	Each "expr" is an expression using ONLY the following:
	1. Integer constants 0 through 255 (0xFF), inclusive. You are
	   not allowed to use big constants such as 0xFFFFFFFF.
	2. Function arguments and local variables (no global variables).
	3. Unary integer operations ! ~
	4. Binary integer operations & ^ | + << >>
    
	Some of the problems restrict the set of allowed operators even further.
	Each "expr" may consist of multiple operators. You are not restricted to
	one operator per line.

	You are expressly forbidden to:
	1. Use any control constructs such as if, do, while, for, switch, etc.
	2. Define or use any macros.
	3. Define any additional functions in this file.
	4. Call any functions.
	5. Use any other operations, such as &&, ||, -, or ?:
	6. Use any form of casting.
	7. Use any data type other than int.  This implies that you
	   cannot use arrays, structs, or unions.

 
	You may assume that your machine:
	1. Uses 2s complement, 32-bit representations of integers.
	2. Performs right shifts arithmetically.
	3. Has unpredictable behavior when shifting an integer by more
	   than the word size.

EXAMPLES OF ACCEPTABLE CODING STYLE:
	/*
	 * pow2plus1 - returns 2^x + 1, where 0 <= x <= 31
	 */
	int pow2plus1(int x) {
		/* exploit ability of shifts to compute powers of 2 */
		return (1 << x) + 1;
	}

	/*
	 * pow2plus4 - returns 2^x + 4, where 0 <= x <= 31
	 */
	int pow2plus4(int x) {
		/* exploit ability of shifts to compute powers of 2 */
		int result = (1 << x);
		result += 4;
		return result;
	}

FLOATING POINT CODING RULES

	For the problem that requires you to implement a floating-point operation,
	the coding rules are less strict.  You are allowed to use looping and
	conditional control.  You are allowed to use both ints and unsigneds.
	You can use arbitrary integer and unsigned constants.

	You are expressly forbidden to:
	1. Define or use any macros.
	2. Define any additional functions in this file.
	3. Call any functions.
	4. Use any form of casting.
	5. Use any data type other than int or unsigned.  This means that you
	   cannot use arrays, structs, or unions.
	6. Use any floating point data types, operations, or constants.


NOTES:
	1. Use the dpc (data project checker) compiler (described in the handout) to 
	   check the legality of your solutions.
	2. Each function has a maximum number of operators (! ~ & ^ | + << >>)
	   that you are allowed to use for your implementation of the function. 
	   The max operator count is checked by dpc. Note that '=' is not 
	   counted; you may use as many of these as you want without penalty.
	3. Use the btest test harness to check your functions for correctness.
	4. Use the btest checker to formally verify your functions.
	5. The maximum number of ops for each function is given in the
	   header comment for each function. If there are any inconsistencies 
	   between the maximum ops in the writeup and in this file, consider
	   this file the authoritative source.

/*
 * STEP 2: Modify the following functions according the coding rules.
 * 
 *   IMPORTANT. TO AVOID GRADING SURPRISES:
 *   1. Use the dpc compiler to check that your solutions conform
 *      to the coding rules.
 *   2. Use the btest checker to formally verify that your solutions produce 
 *      the correct answers.
 */

#endif

/* 
 * bitAnd - Compute x&y using only ~ and | 
 *   Examples: bitAnd(6, 5) = 4
 *             bitAnd(3, 12) = 0
 *   Legal ops: ~ |
 *   Max ops: 8
 *   Rating: 1

   

 */
int bitAnd(int x, int y) {  

	/*
	Logic:
		~(x & y) = ~x | ~y...negating this give x&y equivilant

		~(~x|~y)
	*/


 return  ~(~x|~y);        
}
/* 
 * conditional - Compute the result of x ? y : z 
 *   Examples: conditional(2, 4, 5) = 4
 *             conditional(0, 1, 2) = 2
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 16
 *   Rating: 3
 */
int conditional(int x, int y, int z) {

	/*
		If x == 0: mask overflows to 00...0, else mask is 11...1
		Returns y or z based on mask
	*/

	int mask = ~0 + !x;			
	return ( mask & y ) | ( ~mask & z ); 

}



/* 

 * negate - Return -x
 *   Examples: negate(1) = -1
 *             negate(0) = 0
 *             negate(-33) = 33
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 5
 *   Rating: 2


 */
int negate(int x) {
	/*Twos comp is ~x + 1 where x is the number to flip the sign of*/

 	return (~x)+1;   
}
/* 
 * isEqual - Return 1 if x == y, else return 0
 *   Examples: isEqual(5, 5) = 1
 *             isEqual(4, 5) = 0
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 5
 *   Rating: 2
 */
int isEqual(int x, int y) {
	/*XOR "^" compares bit difference, ! returns 0 or 1*/
 	return !(x^y);    
}
/* 
 * divpwr2 - Compute x/(2^n), for 0 <= n <= 30
 *   Round toward zero
 *   Examples: divpwr2(15, 1) = 7
 *             divpwr2(-33, 4) = -2

 	0xfffffff 1101 1111 -33
	0xfffffff 1111 1101 -33>>4 = -3
				   1110
	
	1....1 >> 2
	111 ..... 0


	if - and odd
		add 1
	x >> n



	11110001 (-15)
	
	(x + ( (x>>31) & ~((~0) << n )))

	int negative = 1 << 31;

	

	int negCase = ~((~x+1) >> n)+1;
	int posCase = x>>n;

	return (mask & negCase) | (mask & posCase )


 *   Legal ops: ! ~ & ^ | + << >>vim 
 *   Max ops: 15
 *   Rating: 2
 




 */
int divpwr2(int x, int n) {


	/*
 		negTest keeps track of the sign of this number,
		divby2n keeps track of powers of two that the int x will be divisible by.

		This masking is done for rounding by adding in the missing bits necessary before
		being cut off by the bit shift of n bits. 

		a bit shift to the right divides by the specified power of two to begin with
	*/


	int negTest = x>>31;   			//Check sign bit    
	int divby2n = ~((~0) << n );    // 2 divisibility mask
	int addition = ( negTest &  divby2n ); //Necessary addition for rounding
 return (x + addition)  >> n;      //Actual division
}
/* 
 * addOK - Return 0 if x+y will overflow, 1 otherwise
 *   Examples: addOK(0x80000000, 0x80000000) = 0
 *             addOK(0x80000000, 0x70000000) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 3



  because
the result of their sum will be towards 0. If they are the same sign,
the case is checked of whether the sign of the sum is DIFFERENT than the 
sign of the change

 */
int addOK(int x, int y) {

	/*
	If the sign of X and the sign of Y are different, no overflow
	Else
		if the sign of X is different than the sign of sum, overflow

	Note: No need to check if sign of Y is different then sign of sum
			because at that point we have decided x&y have the same sign
	*/


	int signX = x>>31 & 1;
	int signY = y>>31 & 1;
	int sum = x+y;
	int signSum = sum>>31 & 1;


	//pos+neg = either. If this is 0, there will be no overflow
	int pos1neg1 =  signX ^ signY;

	//All pos is 0 if sX is 0 sY is 0 sS is 0
	int all_same = !(signX  ^ signSum);


	return pos1neg1 | all_same;


}
/* 
 * absVal - Return the absolute value of x
 *   Examples: absVal(-1) = 1
 *             absVal(33) = 33


  (100010   ^ 111111) + 1

  mask x >> 31 << 31; # all 0's with positive, all 1s with negative

	int mask = (x >> 31);
	return (x ^ mask ) + !!mask;


 *   You may assume -TMax <= x <= TMax
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 6
 *   Rating: 4



	

 */
int absVal(int x) { //Take that 2's comp!


	/*
		mask is used for whether x is positive or negative

		 x ^ mask + !!mask either yields x, or ~x+1
		(x ^ 00000) + 0  ==  x
		(x ^ 11111) + 1  == ~x + 1 == alternative 2's comp!
	*/

	int mask = x >> 31; 

	return (x ^ mask ) + !!mask; 
}
/* 
 * float_f2i - Return bit-level equivalent of expression (int) f
 *   for floating point argument f.
 *
 *   Argument is passed as unsigned int, but it is to be
 *   interpreted as the bit-level representation of a
 *   single-precision floating point value.
 *
 *   Fractional portion of value should be truncated.
 *   Anything out of range (including NaN and infinity)
 *   should return 0x80000000u.
 *
 *   Legal ops: Any integer/unsigned operations incl. ||, &&, <, >, etc.
 *   Also allowed: if, while
 *   Max ops: 30
 *   Rating: 4
 */
int float_f2i(unsigned uf) {


		/*
		  
		  Sign contains sign bit
		  Exponent mask will hold 8 bits that begin 23 from the right
		  Mantissa (or fraction) will hold 23 rightmost bits

		  -exponent < 0 easy, just round, in the case of an overflow,
		  return 0x80...0

		  -set the return value to be 1<<exponent (first implied bit)

		  -iterate through each exponent place, adding the 2^e if it is set

		  -in the case of an overflow, return 0x80...0

		  -if the sign bit sent, multiply by -1
	
		*/


        int sign = (uf >> 31) & 1; //1 for pos, 0 for neg

        int exponent_mask =  (1 << 8) -1;
        int mantissa_mask =  ~(~0 << 23); //23 1s on the right

        int bias = 127;
        int exponent = (exponent_mask & (uf >> 23)) - bias;
        int mantissa = mantissa_mask & uf;
        int return_val = 1 << exponent; //will hold the int
        int counter = 0;

  		//EDGE CASE CHECKING
        if( exponent < 0){
        	return 0;
        }
        if( (exponent+127) == 0xff ){
        	return 0x80000000u;
        }
        //END EDGE CASE CHECKING



        while( counter <= exponent ){

                //return bit_mask;
                if( mantissa >> (23 - counter) & 0x1 ){
                	return_val += 0x1 << (exponent-counter);
                }
                counter++;

              if( return_val>>31 & 0x1 ){
              	return 0x80000000u;
              }


        }

        if(sign){
        	return_val = -return_val;
        }

        return return_val;



}
