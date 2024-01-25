NVCC=nvcc
CXX=nvc++
CFLAGS=-O2

exe=1-basicMatMul

all: $(exe)

%.o: %.cxx %.hpp
	$(CXX) -c -fPIC $(CFLAGS) $< -o $@
%.o: %.cu
	$(NVCC) -c $(CFLAGS) $< -o $@
1-basicMatMul: 1-basicMatMul.o matmul_utils.o
	$(NVCC) $(CFLAGS) $^ -o $@  $(LDFLAGS) $(LIBCV) -lm
clean:
	rm -f *.o $(exe)
