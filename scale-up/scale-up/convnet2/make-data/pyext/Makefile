# Copyright 2014 Google Inc. All rights reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

INCLUDES := -I./include
COMMONFLAGS :=
CC_ARGS := 

ifndef debug
	CC_ARGS += -O3
endif
CC=g++

OUT_DIR=./bin/$(OUT_SUFFIX)

PYTHON_VERSION=$(shell python -V 2>&1 | cut -d ' ' -f 2 | cut -d '.' -f 1,2)
#LINK_LIBS := -L$(CUDA_INSTALL_PATH)/lib64 `pkg-config --libs python` `pkg-config --libs opencv` -lpthread
LINK_LIBS := -L$(CUDA_INSTALL_PATH)/lib64 `pkg-config --libs python` -lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_features2d -lopencv_flann -lopencv_imgproc -lpthread

INCLUDES += -I$(PYTHON_INCLUDE_PATH) 
OUT_FILE=_MakeDataPyExt.so

all: dir classes $(OUT_FILE)

dir:
	mkdir -p $(OUT_DIR)/src

SOURCES = $(shell echo src/*.cpp)
CLASSES = $(SOURCES:.cpp=.o)

classes: $(CLASSES)

%.o: %.cpp
	$(CC) $(CC_ARGS) -c -fPIC $(BUILD_ARGS) $(COMMONFLAGS) $(INCLUDES) $< -o $(OUT_DIR)/$*.o

$(OUT_FILE): classes
	cd $(OUT_DIR) && $(CC) $(CC_ARGS) $(BUILD_ARGS) $(COMMONFLAGS) -shared -Wl,-no-undefined -o $(OUT_FILE) $(CLASSES) $(LINK_LIBS)
	ln -sf $(OUT_DIR)/$(OUT_FILE) .

clean:
	rm -rf $(OUT_DIR)/*
