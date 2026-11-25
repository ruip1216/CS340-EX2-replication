int main (){
	
	int x = 1, y = 1, z;
	for (int i = 1; i!= 0x3f3f3f3f; i ++){
		z = x + y;
		x = y;
		y = z;
	}
	
	return 0;
} 
