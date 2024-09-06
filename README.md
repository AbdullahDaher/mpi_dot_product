# MPI Dot Product in Fortran

This repository contains an MPI-based parallel implementation of the dot product of two vectors, written in Fortran.

## Project Overview

The purpose of this project is to demonstrate the use of **MPI (Message Passing Interface)** for parallelizing a simple operation like the **dot product**. The dot product is calculated in parallel by distributing portions of the vectors to different processes, and the results are then gathered and combined to produce the final result.

### What is the Dot Product?

The dot product of two vectors `x` and `y` of size `n` is calculated as:

\[
\text{Dot Product} = x_1 \times y_1 + x_2 \times y_2 + \dots + x_n \times y_n
\]

For example, if vectors `x` and `y` both contain 12 elements, and if all elements of `x` are 2 and all elements of `y` are 3, the dot product will be:

\[
\text{Dot Product} = 12 \times (2 \times 3) = 72
\]

## Features

- **MPI-based parallelism**: The program distributes the workload of computing the dot product among multiple processes.
- **Efficient communication**: Uses `MPI_SCATTERV` to distribute vector parts and `MPI_REDUCE` to gather partial results.
- **Scalable**: The program can handle any number of processes, distributing the workload evenly, even when the vector size is not divisible by the number of processes.

## How to Compile and Run

### Prerequisites

To compile and run this program, you will need:

- An **MPI-enabled Fortran compiler** (such as `mpiifort` from the Intel oneAPI toolkit or `gfortran` with MPI support).
- **MPI** (Message Passing Interface) installed on your machine.

### Compilation

To compile the program, use the following command:

```bash
mpiifort -o dot_product_mpi parallel_dot_product.f90

This command compiles the parallel_dot_product.f90 file and generates an executable named dot_product_mpi.

Running the Program
Once the code is compiled, you can run it with multiple processes using mpiexec or mpirun. Here is an example of running the program with 4 processes:
mpiexec -n 4 ./dot_product_mpi

Expected Output
For example, if the vector size is 12, and all elements in vector x are initialized to 2 and all elements in vector y are initialized to 3, the output should look like this:

 Process 0: Initializing vectors x and y with size 12
 x =  2.0000000  2.0000000  2.0000000  2.0000000  2.0000000  2.0000000  
      2.0000000  2.0000000  2.0000000  2.0000000  2.0000000  2.0000000
 y =  3.0000000  3.0000000  3.0000000  3.0000000  3.0000000  3.0000000  
      3.0000000  3.0000000  3.0000000  3.0000000  3.0000000  3.0000000
 Process 0: received local_x =  2.0000000  2.0000000  2.0000000
 Process 0: received local_y =  3.0000000  3.0000000  3.0000000
 Process 0: local dot product =   18.000000
 Process 1: received local_x =  2.0000000  2.0000000  2.0000000
