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

For a specific test case, the exe will first output the test case as follows in several lines:
Case %d:/*%d represents the id of the test case*/
N = ...
Inorder:
....../*the data of inorder traversal in a line*/
Preorder:
....../*the data of preorder traversal in a line*/
Postorder:
....../*the data of postorder traversal in a line*/

THEN,
If the test case contains an impossible result, the exe will output as follows in 2 lines:

Result %d:/*%d represents the id of the test case*/
Impossible/*NO SPACE after, only a '\n' after*/

If the test case contains an unique solution, the exe will output as follows:

Result %d:/*%d represents the id of the test case*/
the first line contains the in-order traversal of the unique tree and after the last element there is no SPACE(just '\n')
the second line contains the pre-order traversal of the unique tree and after the last element there is no SPACE(just '\n') 
the third line contains the post-order traversal of the unique tree and after the last element there is no SPACE(just '\n')
the fourth line contains the level-order traversal of the unique tree and after the last element there is no SPACE(just '\n')

NOTE:
If N is large, for example N==100, and there is a unique solution, the result of order traversal will look like being printed for several lines but it's just normal.

If you want to add your test example to test my program, you can edit the file 'testdata.txt' and do as follows:
1)at the end of the file , print some Enter
2)the first line is N
3)the second, third, fourth lines are partial result of inorder, preorder, postorder repectively
For example, you add the following things 
N = 9
3 - 2 1 7 9 - 4 6
9 - 5 3 - 1 - 6 4
3 1 - - 7 - 6 8 -
the test program(exe) will output this result after you added it as follows at the end of all test results.
3 5 2 1 7 9 8 4 6
9 7 5 3 2 1 8 6 4
3 1 2 5 7 4 6 8 9
9 7 8 5 6 3 2 4 1

③ExplanationOfSomeTestCase.txt
some test cases which is difficult to explain in the short report

④testdata.txt:
stores the test data designed by myself and the sample on PTA