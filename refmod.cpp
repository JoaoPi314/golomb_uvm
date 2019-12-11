#include <stdio.h>

extern "C" void codifica(int dt_i, int *dt_o){
  
	int n, c, k, size;
    int binary[8];
    int *golomb;
    
    int count = 8;
  	printf("Enter an integer in decimal number system\n");
  	scanf("%d", &n);
   	n = n + 1;    
   
  	for (c = 0; c < 8; c++)
  	{
  		k = n >> c;
	
		if (k & 1)
			binary[c] = 1;
	  	else
	  	    binary[c] = 0;
  	}

	for(c = 7; c >= 0; c--){
		if(binary[c] != 1)
	    	count --;
	    else
	    	break;
	}
	
	if(count == 0)
	    count = 8;

    
  	size = (count -1)*2 + 1;
  	golomb = malloc( size* sizeof(int));

  	for(c = (size - 1); c > (size/2); c--)
    	golomb[c] = 0;
    
 	golomb[size/2] = 1;

    for(c = size/2 - 1; c >= 0; c--)
    	golomb[c] = binary[c];
    
 
    dt_o = golomb;
  	free(golomb); 

}