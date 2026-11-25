const int M = 100;

bool flag[M][M];
int a[M][M];

void dfs(int x, int y){
	
	flag[x][y] = 1;
	
	if (x >= M || y >= M){
		return;
	}
	
	int newx = x+1;
	int newy = y+1;
	if (!flag[newx][y]){
		dfs(newx, y);
	}
	if (!flag[x][newy]){
		dfs(newx, y);
	}
	if (!flag[newx][newy]){
		dfs(newx, y);
	}
	
	return;
}

int main (){
	
	int x = 1, y = 1;
	dfs(x, y);
	
	return 0;
} 
