//VS 2019
#define  _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#define MAX_N 100 
#define MAX_M 10000 
#define INF 0x3f3f3f3f 
#define MAX_ITERATION 9999
#define stable 1
#define notstable 0
int n, m = 0; 
int adj[MAX_N][MAX_N]; 
int label[MAX_N]; /*1: in S£¬-1: in T*/ 
int S[MAX_N], T[MAX_N]; 
int cut_size = 0;/*current max cut*/
void generate_graph() {
    m = 0;
    memset(adj, 0, sizeof(adj));
    memset(label, 0, sizeof(label));
    memset(S, 0, sizeof(S));
    memset(T, 0, sizeof(T));
    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            int w = rand() % 100 + 1;
            adj[i][j] = adj[j][i] = w;
            m++;
        }
    }
}
void init_label() {
    for (int i = 0; i < n; i++) {
        label[i] = rand() % 2 ? 1 : -1;
        printf("initial label %d is %d\n", i, label[i]);
    }
}
int judge_satisfied(int u)/*return goodness of node u*/
{
    int delta = 0;
    for (int i = 0; i < n; i++) {
        if (adj[u][i]) {
            if (S[i] * S[u] == -1) {//good edge
                delta += adj[u][i];
            }
            else {
                delta -= adj[u][i];
            }
        }
    }
    return delta;
}
int isstable()
{
    for (int i = 0; i < n; i++)
    {
        if (judge_satisfied(i) < 0)/*some node i is not satisfied*/
        {
            return notstable;
        }
    }
    return stable;
}
int get_unsatisfied()
{
    for (int i = 0; i < n; i++)
    {
        if (judge_satisfied(i) < 0)/*some node i is not satisfied*/
        {
            return i;
        }
    }
    return -1;//error
}
int calc_cut_size() {
    int size = 0;
    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            if (adj[i][j] && label[i] != label[j]) {
                size += adj[i][j];
            }
        }
    }
    return size;
}
void flip_label(int u) {
    label[u] = -label[u];
    S[u] = (S[u] == 1) ? -1 : 1;
    T[u] = (T[u] == 1) ? -1 : 1;
}
void state_flipping() {
    init_label();
    for (int i = 0; i < n; i++) {
        S[i] = (label[i] == 1) ? 1 : -1;/*selected set of node*/
        T[i] = (label[i] == -1) ? 1 : -1;/*set of node not selected*/
    }
    cut_size = calc_cut_size();
    int cnt = 0;
    while (isstable()==notstable && cnt<9999 ) {
        int u = get_unsatisfied();/*try to get node u*/
        int goodness = judge_satisfied(u);/*get goodness*/
        if (goodness < 0) {/*node u is not satisfied*/
            flip_label(u);
            cut_size += (-goodness);
        }
        cnt++;//used for debug by jy
    }
    printf("step is %d\n", cnt);
}

int main() {
    printf("input -1 to end\n");
    scanf("%d", &n);
    //n = 73; 
    while (n != -1)
    {
        cut_size = 0;
        generate_graph();
        srand(time(NULL));
        clock_t start, end;
        start = clock();
        state_flipping();
        end = clock();
        printf("%d\n", cut_size);
        printf("time used is %lf\n", ((double)end - (double)start) / CLOCKS_PER_SEC);
        printf("input -1 to end\n");
        scanf("%d", &n);
    }
    return 0;
}