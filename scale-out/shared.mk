##
 # =====================================================================================
 #
 #       Filename:  shared.mk
 #
 #    Description:  This is the commonly shared configuration file for all Makefile in 
 #                  directory. Please change the items according to your machine.
 #
 #        Version:  1.0
 #        Created:  03/19/2018 03:43:25 PM
 #       Revision:  none
 #       Compiler:  GNU-Make
 #
 #         Author:  Ang Li, PNNL
 #        Website:  http://www.angliphd.com  
 #
 #       Please cite our IISWC-18 paper "Tartan: Evaluating Modern GPU Interconnect 
 #          via a Multi-GPU Benchmark Suite"
 #
 # =====================================================================================
##


SHELL = /bin/bash

# ARCH=sm_61 # this is for GTX1080ti GPU
# ARCH=sm_89 # this is for RTX4090 GPU
ARCH=sm_70 # this is for V100 GPU
# CUDA toolkit installation path
CUDA_DIR = /usr/local/cuda/

# CUDA SDK installation path
SDK_DIR = $(CUDA_DIR)/samples/

# CUDA toolkit libraries
LIB_DIR = $(CUDA_DIR)/lib64

# MPI 
MPI_DIR = /usr/lib/x86_64-linux-gnu/mpich

# compiler
CC = gcc
CC_FLAGS = -O3 

MPICC = mpicc
MPICC_FLAGS = -O5

MPICXX = mpic++

# CUDA compiler
NVCC = $(CUDA_DIR)/bin/nvcc
NVCC_FLAGS = -arch=$(ARCH)  -O3 
# Link
NVCC_INCLUDE = -I. -I$(CUDA_DIR)/include -I$(SDK_DIR)/C/common/inc -I../../common/inc/ -I$(SDK_DIR)/shared/inc -I$(MPI_DIR)/include -I$(SDK_DIR)/Common
NVCC_LIB =-lcuda -lmpi_ibm # -lmpich -lmpl # -lnccl
NVCC_LIB_PATH = -L. -L$(SDK_DIR)/C/lib -L$(LIB_DIR)/ -L$(SDK_DIR)/shared/lib -L$(MPI_DIR)/lib -L/usr/lib/ -L/usr/lib64  -L/ccs/home/angli/tartan/Collective/nccl_2.0/lib -L../../common/libconfig-1.4.9/.libs/

TARTAN_COMMON = -I/workdir/Tartan/scale-out/common/inc
LINK_FLAG = $(NVCC_INCLUDE) $(NVCC_LIB_PATH) $(NVCC_LIB) $(TARTAN_COMMON) -lstdc++ -lm
