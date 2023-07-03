#include <stdio.h>
#include <stdlib.h>
#include <time.h>
unsigned long long n;/*the power of the result*/
unsigned int k[3];/*the repeated time of the function set by people*/
double x = 1.0001;/*the base number of the result*/
double result;
clock_t start, stop;/*start and stop time of the function*/
double duration;/*the total time the function uses*/ 
double Algorithm1(double x, unsigned long long power)
{
	double result = x;/*the original value is x*/
	for(unsigned long long i = 1 ; i <= power - 1; i++)
		result *= x;/*use n-1 multiple*/
	return result;
}
double Algorithm2_iterative(double x, unsigned long long power)
{
	double result = 1;/*the original value is x^0 = 1*/
	while(power)/*the condition of the loop*/
	{
		if(power % 2 == 0)
		{
			power /= 2;/*take the front bits*/
			x *= x; /*x multipled by itself*/
		}
		else
		{
			power -= 1;
			result *= x;/*X^(2N+1) == X^N * X^N * X for every X*/
			power /= 2;/*take the front bits*/
			x *= x;/*x multipled by itself*/ 		
		}
	}	
	return result;/*return the result*/
}
double Algorithm2_recursive(double x, unsigned int N)
{
	if(N == 0)
		return 1;/*X^0 == 1 for every X*/
	if(N == 1)
		return x;/*X^1 == X for every X*/	
	if(N % 2 == 0)
		return Algorithm2_recursive(x * x, N / 2);/*X^(2N) == X^N * X^N for every X*/
	else
		return Algorithm2_recursive(x * x, N / 2) * x;/*X^(2N+1) == X^N * X^N * X for every X*/
}
int main()
{
	FILE *fp = fopen("testdata.txt","r");/*read data*/
	while( !feof(fp) )
	{
		fscanf(fp,"%d\n",&n);
		printf("n == %d\n",n);/*print introduction*/
		fscanf(fp,"%d %d %d", k, k+1, k+2);
		printf("iteration time k(within unsigned int) for Algorithm1, Algorithm2-iterative, Algorithm2-recursive respectively: %d %d %d\n",k[0],k[1],k[2]);/*print introduction*/
		start = clock();/*records the beginning of the function*/
		for(int j = 1 ; j <= k[0] ; j++)/*call the function k times*/
			result = Algorithm1(x, n);/*call the function calculating x^n*/
		stop = clock();/*records the stop of the function*/
		duration = (double)(stop - start) / CLK_TCK;/*records the duration of the function*/
		printf("Total time of calculating x^%d = %lf working %d times is %lf	seconds, wasting %ld ticks by algorithm1\n",n,result,k[0],duration,stop-start);/*print the time to console*/
		
		start = clock();/*records the beginning of the function*/
		for(int j = 1 ; j <= k[1] ; j++)/*call the function k times*/
			Algorithm2_iterative(x, n);
		stop = clock();/*records the stop of the function*/
		duration = (double)(stop - start) / CLK_TCK;/*records the duration of the function*/
		printf("Total time of calculating x^%d = %lf working %d times is %lf seconds, wasting %ld ticks iteratively by algorithm2\n",n,result,k[1],duration,stop-start);/*print the time to console*/					
		
		start = clock();/*records the beginning of the function*/
		for(int j = 1 ; j <= k[2] ; j++)/*call the function POW k times*/
			Algorithm2_recursive(x, n);
		stop = clock();/*records the stop of the function*/
		duration = (double)(stop - start) / CLK_TCK;/*records the duration of the function*/
		printf("Total time of calculating x^%d = %lf working %d times is %lf seconds, wasting %ld ticks recursively by algorithm2\n",n,result,k[2],duration,stop-start);/*print the time to console*/				
	}/*test the time repestively*/
	fclose(fp);
	system("pause");
	return 0;
}
