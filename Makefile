NVCC=nvcc
CXX=nvc++
CFLAGS=-O2

exe=2-basicMatMulTiled

all: $(exe)

%.o: %.cxx %.hpp
	$(CXX) -c -fPIC $(CFLAGS) $< -o $@
%.o: %.cu
	$(NVCC) -c $(CFLAGS) $< -o $@
2-basicMatMulTiled: 2-basicMatMulTiled.o matmul_utils.o
	$(NVCC) $(CFLAGS) $^ -o $@  $(LDFLAGS) $(LIBCV) -lm
clean:
	rm -f *.o $(exe)
