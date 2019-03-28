CC=gcc
AR=ar rcs 
O_DIR = ./_build
I_DIR = ./include
LIBS  = ./_build/libs/
dir_guard=mkdir -p $(@D)

SYSTEM_LB = _build/libs/libsystem.a

HEX = ./_build/final.hex

SOURCES := $(wildcard src/*.cpp)
MAIN    := $(wildcard *.cpp)
OBJECTS := $(SOURCES:.cpp=.o)
MAIN_OBJECTS := $(MAIN:.cpp=.o)
MAIN_OBJECTS := $(addprefix $(O_DIR)/,$(MAIN_OBJECTS))
OBJECTS := $(addprefix $(O_DIR)/,$(OBJECTS))

all: $(HEX)
	
$(MAIN_OBJECTS):$(MAIN) $(OBJECTS)
	@$(dir_guard)
	@$(CC) -c -I$(I_DIR) $< -o $@

$(OBJECTS): $(SOURCES)
	@$(dir_guard)
	@$(CC) -c -I$(I_DIR) $< -o $@

$(HEX):$(MAIN_OBJECTS) $(SYSTEM_LB)
	$(dir_guard)
	$(CXX) $(MAIN_OBJECTS) -o $@ -L$(LIBS) -lsystem  

$(SYSTEM_LB):$(OBJECTS)
	@$(dir_guard)
	@$(AR) $@ $^
clean:
	@echo "CLEAN"
	@rm -rf $(O_DIR)