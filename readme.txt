Chetan Patil 		cpatil2@binghamton.edu
Samarth Parikh 		sparikh3@binghamton.edu

Yeah, the code is successfully tested on bingsuns


compile using command:	make
Execute using command:  ./calc testfile.txt


Our calc.l file do a lexical analysis job. 

Our calc.y file do a text parsing job.
As per the grammer given in assignment all the rules are produced in calc.y


For nested brackets problem:

we attach one extra variable with every identifier called as level, indicting the nesting level.
so whenever '{' is detected we increment the level of nesting by 1.
   whenever '}' is detected we decrement the level of nesting by 1.
Thus all identifiers are saved as triplet(name,value,level_of_nesting) into a symbol table array.
