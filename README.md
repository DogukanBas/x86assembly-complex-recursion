# x86assembly-nested-recursion

𝐷(𝑛) = {
    0 , 𝑛 = 0
    1 , 𝑛 = 1,2
    𝐷(𝐷(𝑛 − 1)) + 𝐷(𝑛 − 1 − 𝐷(𝑛 − 2)) , 𝑛 ≥ 3

}

Unlike in high level languages(c, c++,python) in assembly languages, its the programmer's duty to arrange the stack, pushing Segment and Instruction pointers to the stack to know where to return after the function is executed. And 
nested loops are harder to implement. In this problem I have implemented a nested  recursion function. As given above. 

Also in the XXX_B file, I have implemented the same function using dynamic programming aproach. Which works faster as it doesn't re-calculate already calculated values
