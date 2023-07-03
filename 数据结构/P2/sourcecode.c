#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#define max(a,b) ((a)>(b))?(a):(b)
#define maxn 117
#define preorderTraversal -1
#define inorderTraversal 0
#define postorderTraversal 1
#define Enter 0
#define Space 1
#define LeftSubtree 0
#define RightSubtree 1
#define null 0
typedef enum{
	false,true
}bool;
int inorder[maxn], preorder[maxn], postorder[maxn];/*map: subscript in array --> number in order*/
int inorderReMap[maxn], preorderReMap[maxn], postorderReMap[maxn];/*map: number in order --> subscript in array*/
int inorderCount[maxn], preorderCount[maxn], postorderCount[maxn];/*map: number --> appearance times in 1 order*/
int treeNodeData[maxn];/*map: nodeAddress --> data of the node*/
int tree[maxn][2];/*final result tree:tree[root][0] -- leftsubtree node address;tree[root][1] -- rightsubtree node address*/
int appearanceCount[maxn];/*map: number --> appearance times*/
int root;/*root node address*/
int format;/*control to output space or enter*/ 
int n;/*the number of nodes*/
/****
name:createTree
parameter: 
int *index:pointer to the root in array tree[max][2] to write address of root node into it
int inorderLeftBound:the min subscript in inorder array processed
int inorderRightBound:the max subscript in inorder array processed
int preorderLeftBound:the min subscript in preorder array processed
int preorderRightBound:the max subscript in preorder array processed 
int postorderLeftBound:the min subscript in postorder array processed
int postorderRightBound:the max subscript in postorder array processed
return type:bool
return value:true if creation is successful, false if unsuccessful
instruction:
create the tree recursively
the process are as follows:
1)find i that makes inorder[i] = root in postorder and preorder
2)if root in preorder and postorder are different, then given data is wrong, fail
3)if data is correct, recheck whether i is root by remapping i to preorder/inorder/postorder if data is known
4)if (3) goes right, increase possible case
5)if there is only 1 possible solution, then succeed
****/
bool createTree(int *index, int inorderLeftBound, int inorderRightBound, 
				int preorderLeftBound, int preorderRightBound, 
				int postorderLeftBound, int postorderRightBound)
{
	int possibleCase = 0;/*possible cases in creating a tree according to given condition*/
	if (inorderLeftBound > inorderRightBound)/*divide the inorder array to find solution, end recursion*/ 
    {
		*index = null; 
		return true;
	}/*end if*/
	for (int i=inorderLeftBound; i<=inorderRightBound; i++)/*list every possibility i for root of subtree*/
	{
		/*preorder[preorderLeftBound] is root, but inorder[i] is not root-->fail in finding tree root for this i*/
		if (inorder[i]!=0 && preorder[preorderLeftBound]!=0 && inorder[i] != preorder[preorderLeftBound]) 
			continue;/*creation fail for i*/

		/*postorder[postorderRightBound] is root, but inorder[i] is not root-->fail in finding tree root for this i*/
		if (inorder[i]!=0 && postorder[postorderRightBound]!=0 && inorder[i] != postorder[postorderRightBound]) 
			continue;/*creation fail for i*/

		/*the first num in preorder and the last num in postorder are all root of subtree, but in practical they are different*/
		if (preorder[preorderLeftBound]!=0 && postorder[postorderRightBound]!=0 && preorder[preorderLeftBound] != postorder[postorderRightBound]) 
			return false;/*root different-->creation fail*/

		/*if i isn't root, inorder[i] should differ from the first num of preorder and the last num of postorder*/
		int temp = max(inorder[i], max(preorder[preorderLeftBound], postorder[postorderRightBound]));
		
		/*if i is root, data of root can remap to root i in inorder*/
		if (inorderReMap[temp]!=0 && inorderReMap[temp] != i) 
			continue;/*creation fail for i*/

		/*if i is root, data of root can remap to root i in preorder*/
		if (preorderReMap[temp]!=0 && preorderReMap[temp] != preorderLeftBound) 
			continue;/*creation fail for i*/

		/*if i is root, data of root can remap to root i in postorder*/
		if (postorderReMap[temp]!=0 && postorderReMap[temp] != postorderRightBound) 
			continue;/*creation fail for i*/

		/*create left subtree recursively*/
		if (createTree(&tree[i][LeftSubtree], inorderLeftBound, i-1, preorderLeftBound+1, preorderLeftBound+i-inorderLeftBound, postorderLeftBound, postorderLeftBound+i-inorderLeftBound-1)==false) 
			continue;/*creation fail*/

		/*create right subtree recursively*/
		if (createTree(&tree[i][RightSubtree], i+1, inorderRightBound, preorderLeftBound+i-inorderLeftBound+1, preorderRightBound, postorderLeftBound+i-inorderLeftBound, postorderRightBound-1)==false) 
			continue;/*creation fail*/

		/*successfully find root address of subtree:i*/
		treeNodeData[*index = i] = temp;
        possibleCase++;
		if(possibleCase > 1)/*more than 1 possibilities means uncertainty and failure*/
			return false;
	}
    return possibleCase==1?true:false;/*only 1 possible case means the certain tree*/
}
/****
name:outputResult
parameter: 
int root: the address of the root node
int pattern: the traversal pattern of the tree
pattern=-1     preorderTraversal
pattern=0     inorderTraversal
pattern=1     postorderTraversal
return type:void
instruction:
the function output the traversal pattern according to the parameter named pattern
the procedure is as follows
1)preorderTraversal
print --> left --> right
2)inorderTraversal
left --> print --> right
3)postorderTraversal
left --> right --> print
NOTE : if print the first number, do not print out space
****/
void outputResult(int root, int pattern)
{
	if (root==null)/*null node means to finish traversaling*/ 
		return;
	if (pattern == preorderTraversal)/*this if prints the data of root in preorderTraversal*/
	{
		if(format==Space)
			printf(" ");
		printf("%d",treeNodeData[root]);
		format = Space;
	}/*end if*/
		outputResult(tree[root][LeftSubtree], pattern);/*traversal left subtree*/
	if (pattern == inorderTraversal)/*this if prints the data of root in inorderTraversal*/
	{
		if(format==Space)
			printf(" ");
		printf("%d",treeNodeData[root]);
		format = Space;
	}/*end if*/
		outputResult(tree[root][RightSubtree], pattern);/*traversal right subtree*/
	if (pattern == postorderTraversal)/*this if prints the data of root in postorderTraversal*/
	{
		if(format==Space)
			printf(" ");
		printf("%d",treeNodeData[root]);
		format = Space;
	}/*end if*/
}
/****
name:outputLevelorder
parameter: void
return type:void
instruction:
the array queue stimulates the queue for level order traversal
front and rear are the pointers accordingly
****/
void outputLevelorder()/*level order traversal*/
{
	int queue[2*maxn], front=0, rear=0;
	queue[rear++]=root;/*initial condition*/
	printf("%d", treeNodeData[root]);
	/*since given n must be positive, we do not consider the case when n=0/t[root]=null*/
	while (front!=rear)/*while queue is not empty,dequeue a node to print out the data and enqueue it's leftchild and rightchild if they're not null*/
	{
		int tempRoot = queue[front++];/*dequque*/
		if (tree[tempRoot][LeftSubtree]!=null)/*this if enqueue the leftchild and print the data out if it's not null*/
		{
			queue[rear++]=tree[tempRoot][LeftSubtree];
			printf(" %d", treeNodeData[tree[tempRoot][LeftSubtree]]);
		}/*end if*/
		if (tree[tempRoot][RightSubtree]!=null)/*this if enqueue the rightchild and print the data out if it's not null*/
		{
			queue[rear++]=tree[tempRoot][RightSubtree];
			printf(" %d", treeNodeData[tree[tempRoot][RightSubtree]]);
		}/*end if*/
	}/*end while*/
}
/****
name:AnalyzeData
parameter:
char *buffer:starting address of string
return type:int
return value:the number analyzed from the buffer
instruction:
return 0 if get '-'
return positive integer number if get it
****/
int AnalyzeData(char *buffer)
{
	if (buffer[0] == '-')/*special case: '-' is regarded as 0*/
		return 0;
	/*normal case: get a number*/
	int number = 0;
	for (int i = 0; buffer[i]!='\0'; i++)/*this for transform char to number*/
		number = number * 10 + buffer[i] - '0';
	return number;
}
 
int main()
{
	int missingNumber = 0;/*missing number in the input in range from 1 to n*/
	int residue = 0;/*keep the index of the missing number*/
	int testCase = 1;/*mark the case number*/
	int multinumber = 0;/*whether in a traversal exists a number for more than 1 times*/
	int zeroCount = 0;/*count 0s in one traversal*/
	int sum = 0;/*temp variable for patching the data if only 1 number is missing in one traversal*/
	int inorderAllZero = 1;/*if inorder are all 0s or not*/
	char buffer[11];
	FILE *fp=fopen("testdata.txt","r");
	while(!feof(fp))/*while loop for test*/
	{
		/*reset the data for consecutive test*/
		inorderAllZero = 1;
		sum = 0;
		residue = 0;
		multinumber = 0;
		root = 0;
		missingNumber = 0;
		memset(preorder, 0, sizeof(preorder));
		memset(inorder, 0, sizeof(inorder));
		memset(postorder, 0, sizeof(postorder));
		memset(treeNodeData, 0, sizeof(treeNodeData));
		memset(preorderReMap, 0, sizeof(preorderReMap));
		memset(inorderReMap, 0, sizeof(inorderReMap));
		memset(postorderReMap, 0, sizeof(postorderReMap));
		memset(appearanceCount, 0, sizeof(appearanceCount));
		memset(inorderCount, 0, sizeof(inorderCount));
		memset(preorderCount, 0, sizeof(preorderCount));
		memset(postorderCount, 0, sizeof(postorderCount));
		memset(tree, 0, sizeof(tree));
		/*end for clearing*/
		fscanf(fp, "%d\n", &n);
		printf("Case %d:\nN = %d\nInorder:\n",testCase,n);
		for (int i = 1; i <= n; i++)/*this for get inorder traversal from buffer*/
		{
			memset(buffer,'\0',sizeof(buffer));
			fscanf(fp, "%s", buffer);
			printf("%s ",buffer);
			inorder[i] = AnalyzeData(buffer);
			if(inorder[i] != 0)/*this if check whether inoder is empty or not*/
				inorderAllZero = 0;
			appearanceCount[inorder[i]]++;
			inorderCount[inorder[i]]++;
			inorderReMap[inorder[i]] = i;
		}/*end for*/
		/*modify inorder(only token 1 number-->just add it)*/
		zeroCount = 0;  sum = n*(n+1)/2;
		for(int i = 1; i <= n ; i++)
		{
			if(inorder[i] == 0)/*this if count 0s in inorder and keep the corresponding subscript*/
			{
				zeroCount += 1;
				residue = i;
			}/*end if*/	
			sum -= inorder[i];/*every time take a number 'off' to find the missing number from 1 to n*/				
		}
		if(zeroCount == 1)/*this if handles: 0 appears only 1 time, which means data can be patched*/
		{
			inorder[residue] = sum;
			appearanceCount[sum]++;	
		}/*end if*/
		for(int i = 1; i <= n ; i++)/*this for counts whether a number appears more than 1 time in inordertraversal*/
			if(inorder[i]!=0 && inorderCount[inorder[i]] > 1)
				multinumber = 1;
		printf("\nPreorder:\n");
		for (int i = 1; i <= n; i++)/*this for get preorder traversal from buffer*/
		{
			memset(buffer,'\0',sizeof(buffer));
			fscanf(fp, "%s", buffer);
			printf("%s ",buffer);
			preorder[i] = AnalyzeData(buffer);
			appearanceCount[preorder[i]]++;
			preorderCount[preorder[i]]++;
			preorderReMap[preorder[i]] = i;
		}/*end for*/
		zeroCount = 0;  
		sum = n*(n+1)/2;/*sum is the sum of 1,2,...n*/
		for(int i = 1; i <= n ; i++)
		{
			if(preorder[i] == 0)/*this if count 0s in preorder and keep the corresponding subscript*/
			{
				zeroCount += 1;
				residue = i;
			}	
			sum -= preorder[i];/*every time take a number 'off' to find the missing number from 1 to n*/		
		}
		if(zeroCount==1)/*this if handles: 0 appears only 1 time, which means data can be patched*/
		{
			preorder[residue] = sum;
			appearanceCount[sum]++;	
		}/*end if*/
		for(int i = 1; i <= n ; i++)/*this for counts whether a number appears more than 1 time in preordertraversal*/
			if(preorder[i]!=0 && preorderCount[preorder[i]] > 1)
				multinumber = 1;
		printf("\nPostorder:\n");
		for (int i = 1; i <= n; i++)/*this for get postorder traversal from buffer*/
		{
			memset(buffer,'\0',sizeof(buffer));
			fscanf(fp, "%s", buffer);
			printf("%s ",buffer);
			postorder[i] = AnalyzeData(buffer);
			appearanceCount[postorder[i]]++;
			postorderCount[postorder[i]]++;
			postorderReMap[postorder[i]] = i;
		}/*end for*/
		zeroCount = 0;  sum = n*(n+1)/2;
		for(int i = 1; i <= n ; i++)
		{
			if(postorder[i] == 0)/*this if count 0s in postorder and keep the corresponding subscript*/
			{
				zeroCount += 1;
				residue = i;
			}/*end if*/	
			sum -= postorder[i];/*every time take a number 'off' to find the missing number from 1 to n*/				
		}
		if(zeroCount==1)/*this if handles: 0 appears only 1 time, which means data can be patched*/
		{
			postorder[residue] = sum;
			appearanceCount[sum]++;
		}/*end if*/
		for(int i = 1; i <= n ; i++)/*this for counts whether a number appears more than 1 time in postordertraversal*/
			if(postorder[i]!=0 && postorderCount[postorder[i]] > 1)
				multinumber = 1;			
		printf("\n");
		for (int i = 1; i <= n; i++)/*this for traversals from 1 to n*/
		{
			if (appearanceCount[i]==0)/*this if counts the missing number and keep the missing number if missingNumber is 1*/
			{
				missingNumber++;
				residue = i;
			}/*end if*/
		}/*end for*/
		/*if the tree has at least 2 nodes then must build tree by inoder and pre/postorder*/
		/*in a traversal, there exists a number for more than 1 time, the data is wrong*/
		/*1-n there at least 2 numbers missing, that means we cannot identify the tree*/
		/*if we cannnot build the tree, that also means it's impossible*/
		if((inorderAllZero && n!=1) || multinumber || missingNumber > 1 || createTree(&root, 1, n, 1, n, 1, n)==false) 
	        printf("Result %d:\nImpossible\n\n\n",testCase++);
		else/*else branch handles tree successfully built*/
		{
			for (int i = 1; i <= n; i++)/*this for find the only treeNodeData[i] which is 0 and give t[i](=0) the very missing number*/
				if (treeNodeData[i]==0)
					treeNodeData[i] = residue;
			printf("Result %d:\n",testCase++);
			/*output inorder, preorder, postorder, levelorder accordingly*/
			format = Enter;/*avoid outputing a space at the begin of the line*/
			outputResult(root, inorderTraversal);/*inorderTraversal*/
			/*output an Enter to start a new line*/
			printf("\n");
			format = Enter;
			outputResult(root, preorderTraversal);/*preorderTraversal*/
			printf("\n");
			format = Enter;
			outputResult(root, postorderTraversal);/*postorderTraversal*/
			printf("\n");
			format = Enter;
			outputLevelorder();/*levelorderTraversal*/
			printf("\n\n\n");/*end for showing one test result*/
			/*end for output inorder, preorder, postorder, levelorder accordingly*/
		}
	}
	fclose(fp);
	system("pause");
	return 0;
}


