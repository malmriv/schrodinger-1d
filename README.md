# 1D Schrödinger equation.

This simulation solves the Schrödinger equation for a single, 1D wave passing through a potential. The R script is a wrap for the Fortran program, which performs the actual computations. The program actually follows the guidelines provided by my professor, and therefore the specifics of this program are not intended to be understood by a general user. My workflow has been like this:

1. Compile the program.
2. Open the R script.
3. Set the working directory in the same folder as the Fortran program.
4. Edit the parameters of the simulation (in the first lines).
3. Execute the R script as a local job.

The R script will generate a .txt file with a single row of numbers, which the Fortran program will read. Then, the program will create a file with a single column of values (the square of the wave function). The R wrap will read it, plot an animation and also a graph with the evolution of the deviation in the norm for each iteration. Some results can be seen in schrodinger-1d/examples.
