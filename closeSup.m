function closeSup(dev_handle)  
    setSup(0,0,0,0,0,0,0,0,0,450,450,450,450,450,450,450,450,450,dev_handle);
    pause(1);
    fclose(dev_handle);
    
    instrreset
    