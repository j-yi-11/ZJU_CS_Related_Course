//VS 2019
#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<time.h>
#define MAXN 33
#define MINN 17
#define MAXW 124
#define MINW 59
#define MAXH 120
#define MINH 21
#define maxn 9999
int n,w;
struct strip {
    int weight, height;
}s[maxn];
int cmp(struct strip* a, struct  strip*b)
{
    if (a->height < b->height)
        return 1;
    else
        return -1;
}
int main()
{
    srand(time(NULL));
        printf("input n and w(n==-1 means exit)\n");
        printf("n = "); scanf("%d", &n);
        printf("w = "); scanf("%d", &w);
        while (n != -1)
        {
            if (w <= 1) w = 3;
            memset(s, 0, sizeof(s));
            for (int i = 1; i <= n; ++i)
            {
                s[i].height = rand() % (MAXH - MINH) + MINH;
                s[i].weight = rand() % (w - 1) + 1;
            }
            double NFstart = 0, NFend = 0;
            NFstart = clock();
            /*next fit*/
            qsort(s + 1, n, sizeof(struct strip), cmp);
            int h = s[1].height;//1
            int t = 0;
            int level = 0;
            for (int i = 1; i <= n; i++)//[1,n]
            {
                if (w - t >= s[i].weight)//not too long to be placed in this level
                    t += s[i].weight;
                else
                {
                    t = s[i].weight;
                    h += s[i].height;//new level
                }
            }
            NFend = clock();
            printf("n is %d , w is %d\n", n, w);
            for (int i = 1; i <= n; i++)
            {
                printf("%d weight %d height %d \n", i, s[i].weight, s[i].height);
            }
            printf("NFDH answer is %d\n", h);
            printf("NFDH time is %lf ms\n", ((double)(NFend)-(double)(NFstart)));
            printf("input n and w(n==-1 means exit)\n");
            printf("n = "); scanf("%d", &n);
            if (n == -1) break;
            printf("w = "); scanf("%d", &w);
        }
    return 0;
}
