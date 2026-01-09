BENCH_DIR="$(pwd)"

export CFLAGS="${CFLAGS} -Wl,--allow-multiple-definition"

mkdir -p ${BENCH_DIR}/build/${PLATFORM}/${USAGE}/obj
cp -r ${BENCH_DIR}/src/* ${BENCH_DIR}/build/${PLATFORM}/${USAGE}/obj/

# Compile libtiff first
make -C ${BENCH_DIR}/build/${PLATFORM}/${USAGE}/obj/libtiff
make -C ${BENCH_DIR}/build/${PLATFORM}/${USAGE}/obj/libtiff install

# Compile volrend
export CFLAGS="${CFLAGS} -I${BENCH_DIR}/build/${PLATFORM}/${USAGE}/libtiff/include"
export LDFLAGS="${LDFLAGS} -L${BENCH_DIR}/build/${PLATFORM}/${USAGE}/libtiff/lib -ltiff"

make -C ${BENCH_DIR}/build/${PLATFORM}/${USAGE}/obj version=pthreads
make -C ${BENCH_DIR}/build/${PLATFORM}/${USAGE}/obj install version=pthreads