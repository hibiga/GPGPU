NVCC=nvcc
CXX=nvc++
INCCV=`pkg-config --cflags opencv4`
LIBCV=`pkg-config --libs opencv4`
exe= 2-imgToGrayScale

all: $(exe)

%.o: %.cxx %.hpp
	$(CXX) -fPIC -c $(CFLAGS) $(INCCV)  $< -o $@
%.o: %.cu
	$(NVCC) -c $(CFLAGS) $(INCCV)  $< -o $@

2-imgToGrayScale: 2-imgToGrayScale.o img_utils.o
	$(NVCC) $(CFLAGS) $^ -o $@  $(LDFLAGS) $(LIBCV) -lm

clean:
	rm -f *.o $(exe)
