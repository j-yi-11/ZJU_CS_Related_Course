#include <stdio.h>
#include <time.h>
#include <stdlib.h>
clock_t start, stop;
unsigned long long n;
int k = 1e7;/*iteration*/
int binary_search(int key, int array[], int n)
{
	int low = 0, high = n - 1, mid;/*initial the subscripts*/
	while( low <= high )/*the condition of while*/
	{
		mid = (high + low) / 2;
		if( array[mid] < key )/*not found*/
			low = mid + 1;
		else if( array[mid] > key )/*not found*/
			high = mid - 1;
		else if( array[mid] == key )
			return mid;
	}/*we can ensure we can find the element in the array.*/
}
int main()
{
	FILE *fp = fopen("binary_search.txt","r");/*open the file to load data*/
    int array[150000];/*initial the array, if the size of the array is too large, there will be error*/
	for(int i = 0 ; i < 150000 ; i++)
		array[i] = i + 1 ;/*sort the array*/
	printf("please input power n(within unsigned int):");/*print introduction*/
	while( !feof(fp) )/*input data from keyboard*/
	{
		fscanf(fp,"%d",&n);
		int key = 2;/*the element to find using bsearch*/
		start = clock();/*records the beginning of the function*/
		for(int j = 1 ; j <= k ; j++)/*call the function  k times*/
			binary_search(key, array, n);
		stop = clock();/*records the stop of the function*/
		double duration = (double)(stop - start) / CLK_TCK;/*records the duration of the function*/
		printf("Total time of bsearching 2 in an array of length %d working %d times is %lf seconds, wasting %ld ticks by bsearch\n",n,k,duration,stop-start);/*print the time to console*/
    }
    fclose(fp);
    system("pause");/*echo*/
    return 0;
}
