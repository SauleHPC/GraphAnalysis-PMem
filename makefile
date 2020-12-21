# Compiler
CXX = g++

# Link
LINK = -lpmemobj -lpmem -fopenmp

# Include Directory
IDIR = -Iinclude

# Optimizing Flags
OPT = -O3 -march=native
debug: OPT = -O0

# Flags
CXXFLAGS = -Wall -std=c++17
debug: CXXFLAGS += -g

# Source
srcCPP = $(wildcard ./src/*.cpp) $(wildcard ./src/*/*.cpp)
_objCPP = $(srcCPP:.cpp=.o)
_asmCPP = $(srcCPP:.cpp=.s)
objCPP = $(subst src,obj,$(_objCPP))
asmCPP = $(subst src,asm,$(_asmCPP))

obj = $(objCPP)
asm = $(asmCPP)

out_name=graph_analysis

# Compile
main: $(obj)
	$(CXX) $(CXXFLAGS) $(OPT) $(IDIR) -o $(out_name) $^ $(LINK)

debug: $(obj) 
	$(CXX) $(CXXFLAGS) $(OPT) $(IDIR) -o $(out_name) $^ $(LINK)

assembly: $(asm)

obj/%.o: src/%.cpp | dir_make
	$(CXX) $(CXXFLAGS) $(OPT) $(IDIR) -c -o $@ $^ $(LINK)

asm/%.s: src/%.cpp | dir_make
	$(CXX) $(CXXFLAGS) $(OPT) $(IDIR) -S -o $@ $^ $(LINK)

dir_make:
	@mkdir -p obj asm obj/PMEM asm/PMEM obj/GNUPlot asm/GNUPlot tmp

.PHONY: clean clean_pm

# Clean
clean:
	rm -rf obj/*.o asm/*.asm obj/PMEM/*.o asm/PMEM/*.asm obj/GNUPlot/*.o asm/GNUPlot/*.asm $(out_name) tmp/*
