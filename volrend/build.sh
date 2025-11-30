BENCH_DIR="$(pwd)"

export CFLAGS="${CFLAGS} -Wl,--allow-multiple-definition"

mkdir -p ${BENCH_DIR}/build/${PLATFORM}/obj
cp -r ${BENCH_DIR}/src/* ${BENCH_DIR}/build/${PLATFORM}/obj/

# Compile libtiff first
make -C ${BENCH_DIR}/build/${PLATFORM}/obj/libtiff
make -C ${BENCH_DIR}/build/${PLATFORM}/obj/libtiff install

# Compile volrend
export CFLAGS="${CFLAGS} -I${BENCH_DIR}/build/${PLATFORM}/libtiff/include"
export LDFLAGS="${LDFLAGS} -L${BENCH_DIR}/build/${PLATFORM}/libtiff/lib -ltiff"

make -C ${BENCH_DIR}/build/${PLATFORM}/obj version=pthreads
make -C ${BENCH_DIR}/build/${PLATFORM}/obj install version=pthreads