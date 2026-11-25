int main (){
	
	int x = 1, y = 1, z;
	for (int i = 1; i!= 2147483648; i ++){
		z = x + y;
		x = y;
		y = z;
	}
	
	return 0;
} 
