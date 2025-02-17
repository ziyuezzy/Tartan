################################################################################
#
# Copyright 1993-2012 NVIDIA Corporation.  All rights reserved.
#
# NOTICE TO USER:   
#
# This source code is subject to NVIDIA ownership rights under U.S. and 
# international Copyright laws.  
#
# NVIDIA MAKES NO REPRESENTATION ABOUT THE SUITABILITY OF THIS SOURCE 
# CODE FOR ANY PURPOSE.  IT IS PROVIDED "AS IS" WITHOUT EXPRESS OR 
# IMPLIED WARRANTY OF ANY KIND.  NVIDIA DISCLAIMS ALL WARRANTIES WITH 
# REGARD TO THIS SOURCE CODE, INCLUDING ALL IMPLIED WARRANTIES OF 
# MERCHANTABILITY, NONINFRINGEMENT, AND FITNESS FOR A PARTICULAR PURPOSE.   
# IN NO EVENT SHALL NVIDIA BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL, 
# OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS 
# OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE 
# OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE 
# OR PERFORMANCE OF THIS SOURCE CODE.  
#
# U.S. Government End Users.  This source code is a "commercial item" as 
# that term is defined at 48 C.F.R. 2.101 (OCT 1995), consisting  of 
# "commercial computer software" and "commercial computer software 
# documentation" as such terms are used in 48 C.F.R. 12.212 (SEPT 1995) 
# and is provided to the U.S. Government only as a commercial end item.  
# Consistent with 48 C.F.R.12.212 and 48 C.F.R. 227.7202-1 through 
# 227.7202-4 (JUNE 1995), all U.S. Government End Users acquire the 
# source code with only those rights set forth herein.
#
################################################################################

include ../../../shared.mk

# Location of the CUDA Toolkit binaries and libraries
CUDA_INC_PATH  = $(CUDA_INSTALL_PATH)/include
CUDA_BIN_PATH  = $(CUDA_INSTALL_PATH)/bin
CUDA_LIB_PATH  = $(CUDA_INSTALL_PATH)/lib64

# Common binaries
NVCC            = $(CUDA_BIN_PATH)/nvcc
GCC             = g++
AR				= ar

# CUDA code generation flags
GENCODE_FLAGS   := -arch=$(ARCH)

LDFLAGS   := -L$(CUDA_LIB_PATH) -lcudart
CCFLAGS   := -m64
NVCCFLAGS := -m64

# Debug build flags
ifeq ($(dbg),1)
      CCFLAGS   += -g
      NVCCFLAGS += -g -G
      DBG := debug
else
      DBG := release
      NVCCFLAGS += -O3
      CCFLAGS += -O3
endif

# Add profiler output
ifeq ($(prof),1)
	NVCCFLAGS += --ptxas-options=-v
endif

TARGETDIR := ./bin/$(DBG)
OBJDIR := ./obj/$(DBG)

########## USER STUFF ###########
PYTHON_VERSION=$(shell python -V 2>&1 | cut -d ' ' -f 2 | cut -d '.' -f 1,2)
MODELNAME := _ConvNet
LDFLAGS   += -lpthread -ljpeg -lpython$(PYTHON_VERSION) -L../util -lutilpy -L../nvmatrix -lnvmatrix -L../cudaconv3 -lcudaconv -lcublas -Wl,-rpath=./util -Wl,-rpath=./nvmatrix -Wl,-rpath=./cudaconv3 
INCLUDES      := -I$(CUDA_INC_PATH) -I $(CUDA_SDK_PATH)/Common -I./include -I$(PYTHON_INCLUDE_PATH) -I$(NUMPY_INCLUDE_PATH) $(TARTAN_COMMON)

DEFINES := -DNUMPY_INTERFACE

CUFILES	:= $(shell find . -name "*.cu")
CU_DEPS	:= $(shell find . -name "*.cuh")
CCFILES	:= $(shell find . -name "*.cpp")
C_DEPS	:= $(shell find . -name "*.h")

NVCCFLAGS += --compiler-options '-fPIC'
LDFLAGS += -shared
CCFLAGS += -fPIC
TARGET := $(TARGETDIR)/$(MODELNAME).so

################################################################################
# Set up target and object files
################################################################################
OBJS +=  $(patsubst %.cpp,$(OBJDIR)/%.cpp.o,$(CCFILES))
OBJS +=  $(patsubst %.c,$(OBJDIR)/%.c.o,$(CFILES))
OBJS +=  $(patsubst %.cu,$(OBJDIR)/%.cu.o,$(CUFILES))

# Target rules
all: makedirs $(TARGET)

$(OBJDIR)/%.cu.o : %.cu $(CU_DEPS)
	$(NVCC) $(DEFINES) $(NVCCFLAGS)  $(GENCODE_FLAGS) $(INCLUDES) -o $@ -c $<

$(OBJDIR)/%.cpp.o : %.cpp $(C_DEPS)
	$(GCC) $(DEFINES) $(CCFLAGS) $(INCLUDES) -o $@ -c $<

$(TARGET): $(OBJS)
	$(GCC) $(CCFLAGS) -o $@ $+ $(LDFLAGS) $(EXTRA_LDFLAGS)
	ln -sf $(TARGET) .

makedirs:
	mkdir -p $(TARGETDIR)
	mkdir -p $(OBJDIR)/src

clean:
	rm -rf ./obj
