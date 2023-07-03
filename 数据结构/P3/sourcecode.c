#include<stdio.h>
#include<stdlib.h>
#define NotAVertex -1
#define maxn 1011
#define inf 0xFFFFFFF
typedef enum{
	true , false
}bool;
int distance[maxn];/*map: vertex-->distance from specific source to vertex*/
bool vis[maxn];/*map: vertex-->visited or not*/
int pre[maxn][maxn];/*map: vertex-->all pre node before vertex with shortest path*/
int preSize[maxn];/*map: vertex-->number of pre node*/
int indegree[maxn] , in[maxn];/* in is a same copy of indegree, they both map vertex to its indegree*/
int ScoreThreshold[maxn][maxn], Money[maxn][maxn];
int adj[maxn][maxn];/*use array to represent linked list to simplify operations*/
int adjSize[maxn];/*map: vertex-->outdegree*/
int tempPath[maxn] , path[maxn];/*stack: the path in reversed order*/
int tempPathSize , pathSize;/*corresponding stack pointers*/
int n;/*the number of vertex*/
int m;/*the number of edge*/
int MaxVoucher;/*counter for max voucher*/
/**
* Name : isCyclic
* Parameter : void
* Returning type : bool
* Introduction : use queue to implement topo sort fo a graph
* Return value :
* 1)true if the graph has a cycle
* 2)false if the graph is acyclic
**/
bool isCyclic()
{
	int front = 0 , rear = 0;/*2 pointers for a queue*/
	int queue[2*maxn];
	for( int i = 0 ; i < n ; i++ )/*this for list all vertex adj to vertex u*/
		if( indegree[i] == 0 )/*enqueue the vertex whose indegree is 0*/ 
			queue[rear++] = i;
	int count = 0;/*count the number of vertexes whose indegree can be decreased to 0 when trying topo sorting*/
	while( front != rear )/*queue is not empty means continue to check*/
	{
		int u = queue[front++];
		count++;
		for( int i = 0 ; i < adjSize[u] ; i++ )/*this for list all vertex adj to vertex u*/
			if( --indegree[adj[u][i]] == 0 )/*this if enqueue the vertex whose indegree is 0*/ 
				queue[rear++] = adj[u][i];
	}/*end while*/
	return ( count == n ) ? false : true;/*if all vertexes whose indegree can be decreased to 0, the graph has topo sort */
}
/**
* Name : Dijkstra
* Parameter : int source(the vertex IDnumber)
* Returning type : void
* Introduction : 
* use Dijkstra algorithm for a graph
* start from the vertex numbered source
* if we find more than 1 shortest way from vertex numbered source to u
* we store the vertex u in a stack related to source
* if we find a strictly shorter way from vertex numbered source to u
* we clear the stack related to source and store the vertex u in a stack related to source 
**/
void Dijkstra(int source)
{
	for( int i = 0 ; i < maxn ; i++ )/*this for set all distance to infinity*/
		distance[i] = inf;
	distance[source] = 0 ;/*self to self means distance is 0*/
	while(1)/*the actual part of Dijkstra*/
	{
		int u = NotAVertex , min = inf;
		for(int i = 0 ; i <= n ; i++)/*this for find the next vertex to calculate*/
			if( vis[i] == false && distance[i] < min )/*modify the shortest path*/
			{
				min = distance[i];
				u = i;
			}
		if( u == NotAVertex )/*if we can not change the shortest way, we stop the algorithm*/
			return;
		vis[u] = true;
		for( int i = 0 ; i < adjSize[u] ; i++ )/*this for list all pre node of vertex numbered source*/
		{
			int v = adj[u][i];
			if( vis[v] == false )/*if we have not visited the vertex v, we modify the shortest path*/
				if( distance[u] + ScoreThreshold[u][v] < distance[v] )/*this if shows we find a strictly shorter path*/
				{
					distance[v] = distance[u] + ScoreThreshold[u][v];
					/*this for clear the pre node of shoetest path to v before*/
					for( int j = 0 ; j < maxn ; j++ )
						pre[v][j] = NotAVertex;
					preSize[v] = 0;
					/*end for clearing original vertexes and stores the vertex recently found*/
					pre[v][preSize[v]++] = u;
				}else if( distance[u] + ScoreThreshold[u][v] == distance[v] )/*this else if shows we find an equal shortest path to vertex v*/
					pre[v][preSize[v]++] = u;				
		}/*end for listing*/
	}
}
/**
* Name : dfs
* Parameter : int source(the vertex IDnumber)
* Returning type : void
* Introduction : 
* use dfs algorithm for a graph
* start from the vertex numbered source
* if we reach a vertex numbered n(gathering point) 
* we count the voucher of the temp path and modify the max voucher if necessary
* if we do not reach a vertex numbered n(gathering point) 
* we continue the dfs and try every possibilities of pre node of vertex numbered source
**/
void dfs(int source)
{
	if( source == n )/*this if shows we reach the gathering point*/
	{
		int CurrentVoucher = 0;
		for(int i = tempPathSize - 1 ; i > 0 ; i-- )/*this for calculates the voucher of the path*/
			CurrentVoucher += Money[ tempPath[i] ][ tempPath[i-1] ];/*calculates from behind to before*/
		if( CurrentVoucher > MaxVoucher )/*find a larger voucher*/
		{
			MaxVoucher = CurrentVoucher;
			for( int j = 0 ; j < maxn ; j++ )/*this for records the path of max voucher*/
				path[j] = tempPath[j];
			pathSize = tempPathSize;
			/*end for copying the temppath to path*/
		}/*end if*/
		return;
	}/*end if*/
	tempPath[tempPathSize++] = source;/*push the source vertex to temp stack*/
	for( int i = 0 ; i < preSize[source] ; i++ )/*this for list all pre node of vertex numbered source*/
		dfs(pre[source][i]);
	tempPathSize--;/*pop the source vertex*/
}
/**
* Name : Initial
* Parameter :void
* Returning type : void
* Introduction : 
* set all variable with a reasonable value
**/
void Initial()
{
	for( int i = 0 ; i < maxn ; i++ )/*set the value of 1 dimension variable*/
	{
		vis[i] = false;
		adjSize[i] = 0;
		tempPath[i] = path[i] = NotAVertex;
		indegree[i] = in[i] = 0;
	}/*end for*/
	for( int i = 0 ; i < maxn ; i++ )/*set the value of 2 dimension variable*/
		for( int j = 0 ; j < maxn ; j++ )
		{
			ScoreThreshold[i][j] = inf;/*'distance' set to positive infinity*/
			Money[i][j] = -1;
			adj[i][j] = NotAVertex;
		}/*end for*/	
	MaxVoucher = -1;
	/*empty stack has 0 element*/				
	tempPathSize = 0;
	pathSize = 0;
}
/**
* Name : Clear
* Parameter : int *path
* Returning type : void
* Introduction : 
* set all variable in array path to NotAVertex
**/
void Clear( int *path )
{
	for( int i = 0 ; i < maxn ; i++ )
		*( path + i ) = NotAVertex;
}
int main()
{
	int u, v, score, money, TestCase = 0;
	FILE *fp = fopen("testdata.txt","r");
	while( !feof(fp) )
	{
		Initial();
		fscanf(fp, "%d %d" ,&n ,&m);
		printf("\n\n\ncase %d:\n", ++TestCase);
		for( int i = 0 ; i < m ; i++ )/*this for reading the data*/
		{
			fscanf(fp,"%d %d %d %d ",&u,&v,&score,&money);
			//printf("%d %d %d %d\n", u, v, score, money);
			indegree[v]++;
			in[v]++;
			ScoreThreshold[u][v] = score;
			Money[u][v] = money;
			adj[u][adjSize[u]++] = v;
		}/*end for reading*/
		for( int i = 0 ; i < n ; i++ )/*this for finds the vertexes whose indegree is 0*/
			if( in[i] == 0 )/*this if gather the vertexes*/
			{
				ScoreThreshold[n][i] = 0;/*the distance between gathering point and vertexes whose indegree si 0 is 0*/
				adj[n][adjSize[n]++] = i;/*merge the vertexes whose indegree is 0*/
			}/*end if*/
		Dijkstra(n);/*first take vertex numbered n as gathering point*/
		int k;/*the number of queries*/
		fscanf(fp, "%d ", &k);
		//printf("%d\n",k);
		if( isCyclic() == false )/*this if handles the acyclic graph*/
		{
			printf("Okay.\n");
			for( int i = 0 ; i < k ; i++ )/*this for deals with k queries*/
			{
				fscanf(fp, "%d " ,&u);
				if( in[u] == 0 )/*vertex u is the start of 1 topo sort*/
					printf("You may take test %d directly.\n",u);
				else{/*vertex u is not the start of 1 topo sort*/
					/*clear the stack path and temppath for dfs*/			
					Clear(tempPath);
					tempPathSize = 0;
					Clear(path);
					pathSize = 0;
					/*end for clearing*/
					MaxVoucher = -1;/*set max voucher to negative for finding max*/
					dfs(u);/*take vertex u as source to dfs*/
					for(int j = pathSize - 1 ; j >= 0 ; j--)/*this for print the path in the stack out*/
					{
						printf("%d",path[j]);
						if( j != 0 )/*this if controls whether to output Enter or arrow*/
							printf("->");
						else/*not print the last element*/ 
							printf("\n");
					}/*end for printing*/
				}/*end if*/
			}/*end for handling queries*/
		}else{/*cyclic graph--no topo sort exist*/
			printf("Impossible.\n");
			for( int i = 0 ; i < k ; i++ )/*this for deals with k queries*/
			{
				fscanf(fp, "%d ", &u);
				if( in[u] == 0 )/*vertex u is the start of 1 topo sort*/
					printf("You may take test %d directly.\n",u);
				else/*vertex u is not the start of 1 topo sort*/
					printf("Error.\n");
			}/*end for*/
		}/*end if*/
	}/*end while*/
	fclose(fp);
	system("pause");
	return 0;
}
