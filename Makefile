NVCC=nvcc
CXX=nvc++
CFLAGS=-O2

exe=1-dotNaive

all: $(exe)

%.o: %.cxx %.hpp
	$(CXX) -c -fPIC $(CFLAGS) $< -o $@
%.o: %.cu
	$(NVCC) -c $(CFLAGS) $< -o $@
1-dotNaive: 1-dotNaive.o matmul_utils.o
	$(NVCC) $(CFLAGS) $^ -o $@  $(LDFLAGS) $(LIBCV) -lm
clean:
	rm -f *.o $(exe)
