//VS 2019
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define MAX_LEVEL 16//can be modified by you
typedef struct Node {
    int val;
    int level;
    struct Node** next;
} Node;
typedef struct SkipList {
    Node* head;
} SkipList;
Node* createNode(int val, int level) {
    Node* node = (Node*)malloc(sizeof(Node));
    node->val = val;
    node->level = level;
    node->next = (Node**)calloc(level + 1, sizeof(Node*));
    return node;
}

void destroyNode(Node* node) {
    free(node);
}

SkipList* createSkipList() {
    SkipList* sl = (SkipList*)malloc(sizeof(SkipList));
    sl->head = createNode(INT_MIN, MAX_LEVEL);
    return sl;
}

void destroySkipList(SkipList* sl) {
    Node* p = sl->head;
    while (p != NULL) {
        Node* q = p;
        p = p->next[0];
        free(q);
    }
    free(sl);
}

Node* find(SkipList* sl, int val) {
    Node* p = sl->head;
    for (int i = MAX_LEVEL; i >= 0; i--) {
        while (p->next[i] != NULL && p->next[i]->val < val) {
            p = p->next[i];
        }
    }
    p = p->next[0];
    if (p != NULL && p->val == val) {
        return p;
    }
    return NULL;
}

void insert(SkipList* sl, int val) {
    int level = 0;
    while (rand() % 2 == 0 && level < MAX_LEVEL) {
        level++;
    }
    Node* newNode = createNode(val, level);
    Node* p = sl->head;
    for (int i = MAX_LEVEL; i >= 0; i--) {
        while (p->next[i] != NULL && p->next[i]->val < val) {
            p = p->next[i];
        }
        if (i <= level) {
            newNode->next[i] = p->next[i];
            p->next[i] = newNode;
        }
    }
}

void deleteNode(SkipList* sl, int val) {
    Node* p = sl->head;
    Node* q = NULL;
    for (int i = MAX_LEVEL; i >= 0; i--) {
        while (p->next[i] != NULL && p->next[i]->val < val) {
            p = p->next[i];
        }
        if (p->next[i] != NULL && p->next[i]->val == val) {
            q = p->next[i];
            p->next[i] = q->next[i];
        }
    }
    if (q == NULL)
    {
        printf("node unfound in delete\n");
        return;
    }
    destroyNode(q);
}

void print(SkipList* sl) {//jy use to debug
    Node* p = sl->head->next[0];
    if (p == NULL)
    {
        printf("NULL skip list\n");
        return;
    }
    while (p != NULL) {
        printf("%d ", p->val);
        p = p->next[0];
    }
    printf("\n");
}

int main() {
    srand(time(NULL));
    int n = 999;/*number of nodes to be inserted*/
    printf("input number of nodes to be inserted:(-1 means exit)\n");
    scanf("%d", &n);
    while (n != -1)
    {
        SkipList* sl = createSkipList();
        clock_t insertStart = clock();
        for (int i = 0; i < n; i++)
        {
            insert(sl, 2 * i + 1);//insert 1,3,5...2i+1 into skip list
        }
        clock_t insertEnd = clock();
        printf("time for insert is %lf\n", ((double)insertEnd - (double)insertStart) / CLOCKS_PER_SEC);
        Node* p = NULL;
        clock_t findStart = clock();
        for (int i = 0; i < n; i++)
        {
            p = find(sl, 2 * i + rand() % 2);
            if (p != NULL) {
	//if you want to see skip list, uncomment printf
                //printf("Found %d\n", p->val);//used for debug by jy
            }
            else {
                //printf("Unfound \n");
            }
        }
        clock_t findEnd = clock();
        printf("time for find is %lf\n", ((double)findEnd - (double)findStart) / CLOCKS_PER_SEC);
        clock_t deleteStart = clock();
        for (int i = 0; i < n; i++)
        {
            deleteNode(sl, 2 * i + 1);
        }
        clock_t deleteEnd = clock();
        printf("time for delete is %lf\n", ((double)deleteEnd - (double)deleteStart) / CLOCKS_PER_SEC);
        destroySkipList(sl);
        printf("input number of nodes to be inserted:(-1 means exit)\n");
        scanf("%d", &n);
    }    
    return 0;
}