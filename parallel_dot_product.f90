program parallel_dot_product
  use mpi
  implicit none

  integer :: ierr, rank, size, n, i
  integer, allocatable :: sendcounts(:), displs(:)
  real, allocatable :: x(:), y(:), local_x(:), local_y(:)
  real :: local_dot_product, global_dot_product
  integer :: local_n

  ! Initialize MPI
  call mpi_init(ierr)

  ! Get the rank of the process
  call mpi_comm_rank(mpi_comm_world, rank, ierr)

  ! Get the number of processes
  call mpi_comm_size(mpi_comm_world, size, ierr)

  ! Vector size (12 elements). Can change to any desired size
  n = 12

  ! Allocate the full vectors on the root process
  if (rank == 0) then
     allocate(x(n), y(n))
     x = 2.0  ! Initialize all elements of x to 2
     y = 3.0  ! Initialize all elements of y to 3
     print *, 'Process 0: Initializing vectors x and y with size ', n
     print *, 'x = ', x
     print *, 'y = ', y
  end if

  ! Allocate arrays for send counts and displacements
  allocate(sendcounts(size), displs(size))

  ! Calculate the send counts and displacements for each process
  do i = 1, size
     sendcounts(i) = n / size
     if (i <= mod(n, size)) then
        sendcounts(i) = sendcounts(i) + 1
     end if
  end do

  displs(1) = 0
  do i = 2, size
     displs(i) = displs(i-1) + sendcounts(i-1)
  end do

  ! Each process allocates the local arrays
  local_n = sendcounts(rank+1)
  allocate(local_x(local_n), local_y(local_n))

  ! Scatter the vectors x and y to all processes
  call mpi_scatterv(x, sendcounts, displs, mpi_real, local_x, local_n, mpi_real, 0, mpi_comm_world, ierr)
  call mpi_scatterv(y, sendcounts, displs, mpi_real, local_y, local_n, mpi_real, 0, mpi_comm_world, ierr)

  ! Each process prints the portion of x and y it received
  print *, 'Process ', rank, ': received local_x = ', local_x
  print *, 'Process ', rank, ': received local_y = ', local_y

  ! Compute local dot product
  local_dot_product = 0.0
  do i = 1, local_n
     local_dot_product = local_dot_product + local_x(i) * local_y(i)
  end do

  ! Each process prints its local dot product
  print *, 'Process ', rank, ': local dot product = ', local_dot_product

  ! Use MPI_Reduce to sum the local dot products into the global dot product
  call mpi_reduce(local_dot_product, global_dot_product, 1, mpi_real, mpi_sum, 0, mpi_comm_world, ierr)

  ! Synchronize before printing the result
  call mpi_barrier(mpi_comm_world, ierr)

  ! The root process prints the final global dot product
  if (rank == 0) then
     print *, 'Process 0: Final global dot product is ', global_dot_product
  end if

  ! Finalize MPI
  call mpi_finalize(ierr)

end program parallel_dot_product
