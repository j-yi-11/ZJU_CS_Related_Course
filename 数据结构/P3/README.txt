INSTRUCTIONS:
When you check my project after you unzipped the file from PTA, you should do as follows:
①open sourcecode.c and compile it by Dev C++ to get sourcecode.exe WITHOUT moving them out of the original folder
②open testdata.txt and ExplanationOfSomeTestCase.txt to get some detailed information of test case
③go to the folder named document to open report2-normal.pdf to check my report
IMPORTANT NOTE:
please keep testdata.txt and sourcecode.exe and sourcecode.c in the SAME folder to ensure the program will run properly.

FILE STRUCTURE:

①sourcecode.c
the source code of my project in C

②sourcecode.exe
the test program of my program, you can compile sourcecode.c to get it or unzipped the only zip in folder named sourcecode to get it.

For a specific test case, the exe will output the result of the test case as follows in several lines:
Case %d:/*%d represents the id of the test case*/


If the test case represents a consistent task, the exe will output as follows:
the first line contains 'Okay.' and after that there is no SPACE(just '\n')
the second line to the K+1 th line contain the shortest path if the indegree of the vertex is not 0 and print 'You may take test %d directly.' if the indegree is 0 and and after the last element there is no SPACE(just '\n') 

If the test case represents an inconsistent task, the exe will output as follows:
the first line contains 'Impossible.' and after that there is no SPACE(just '\n')
the second line to the K+1 th line contain 'Error.' if the indegree of the vertex is not 0 and print 'You may take test %d directly.' if the indegree is 0 and and after the last element there is no SPACE(just '\n') 


NOTE:

If you want to add your test example to test my program, you can edit the file 'testdata.txt' and do as follows:
1)at the end of the file , print some Enter
2)the first line is N and M
3)the next M lines are prerequisite relation of 2 tests , with
	 TEST1 TEST2 SCORE BONUS 
4 integers repectively
4)the next single line is K
5)the next line, there are K integers in range from 0 to N-1
For example, you add the following things 
8 15
0 1 50 50
1 2 20 20
3 4 90 90
3 7 90 80
4 5 20 20
7 5 10 10
5 6 10 10
0 4 80 60
3 1 50 45
1 4 30 20
1 5 50 20
2 4 10 10
7 2 10 30
2 5 30 20
2 6 40 60
8
0 1 2 3 4 5 6 7
the test program(exe) will output this result after you added it as follows at the end of all test results.
Okay.
You may take test 0 directly.
0->1
0->1->2
You may take test 3 directly.
0->1->2->4
0->1->2->4->5
0->1->2->6
3->7

③ExplanationOfSomeTestCase.txt
some test cases which is difficult to explain in the short report

④testdata.txt:
stores the test data designed by myself and the sample on PTA