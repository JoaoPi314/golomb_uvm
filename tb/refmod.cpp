#include <stdio.h>
#include <iostream>
#include <stdlib.h>
using namespace std;
extern "C" string codifica(int dt_i){
  
	int c, k, size;
    char binary[8];
    string golomb;
    
    int count = 8;

   	dt_i = dt_i + 1;    
   
  	for (c = 0; c < 8; c++)
  	{
  		k = dt_i >> c;
	
		if (k & 1)
			binary[c] = '1';
	  	else
	  	    binary[c] = '0';
  	}

	for(c = 7; c >= 0; c--){
		if(binary[c] != '1')
	    	count --;
	    else
	    	break;
	}
	
	if(count == 0)
	    count = 8;

    
  	size = (count -1)*2 + 1;
  	//golomb = (char*) malloc( size* sizeof(char));

  	for(c = (size - 1); c > (size/2); c--)
    	golomb[c] = '0';
    
 	golomb[size/2] = '1';

    for(c = size/2 - 1; c >= 0; c--)
    	golomb[c] = binary[c];
    
  	//free(golomb); 

    return golomb;

}