#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
int pushtop=-1;
int poptop=-1;

void push(int pushstack[],int vertex)
{
	pushstack[++pushtop]=vertex;
}

void pop(int pushstack[],int poparr[])
{
	poparr[++poptop]=pushstack[pushtop--];
}

void dfs(int n,int adj_matrix[][n],int pushstack[],int poparr[],bool visited[])
{
	int vertex=pushstack[pushtop];
	for(int i=0;i<n;i++)
	{
		if(adj_matrix[vertex][i]==1)
		{
			if(!visited[i])
			{
				visited[i]=true;
				printf(" %d",i);
				push(pushstack,i);
				dfs(n,adj_matrix,pushstack,poparr,visited);

			}
		}
	}

	pop(pushstack,poparr);
}

int main()
{
	printf("Enter number of vertices: ");
	int n;
    scanf("%d",&n);
	int adj_matrix[n][n];
	printf("Enter adjacency matrix: ");
	bool visited[n];
	for(int i=0;i<n;i++)
	{ 
		visited[i]=false;
		for(int j=0;j<n;j++)
			scanf("%d",&adj_matrix[i][j]);
	}
    int pushstack[n];
    int poparr[n];
	printf("output: ");
	for(int i=0;i<n;i++)
      if(!visited[i])
      {
        printf(" %d",i);
        visited[i]=true;
        push(pushstack,i);
        dfs(n,adj_matrix,pushstack,poparr,visited);
      }
	printf("\npoporder:");
	for(int i=0;i<=poptop;i++)
		printf(" %d",poparr[i]);
	printf("\n");
}