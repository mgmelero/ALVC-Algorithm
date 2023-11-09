# ALVC-Algorithm



## REPOSITORY ORGANISATION

This repository stores the algorithms of the project and all their components.
The ***Main folder*** contains the main algorithm that performs the entire signal analysis process.
The ***Statistics folder*** contains the statistical analysis algorithm that performs the statistical analysis of the previous results.
And the ***Pruebas folder*** contains other functions that I wanted to test to optimise some processes but which are not in the developed algorithm.



## HOW IT WORKS

If you want to run the ***signal analysis algorithm***, you must follow the steps below:
  1. You have to download this repository on your own computer.
  2. Open MATLAB.
  3. Choose the downloaded repository in MATLAB and add it to the MATLAB search path.
  4. Now, you can open ***Main.m*** algorithm and configure it.
      - Select the process you want to carry out.
      - Select the type of signal you want to work with.
      - And select all the repositories that are needed.
  5. Run the program.

If you want to run the ***statistical analysis algorithm***, you must follow the same steps as the previous algorithm but in this case, you must open ***MAIN_Statictics_mod.m*** algorithm. 
 


## IMPORTANT
> It is important to know that the database requires specific structuring. If you use another database, you have to modify the FilesLoad.m function to adapt it to your database.
> It is also important to know, that statistical analysis algorithm can only be carried out after obtaining the results of the previous processes.
