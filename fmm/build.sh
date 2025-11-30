BENCH_DIR="$(pwd)"

mkdir -p ${BENCH_DIR}/build/${PLATFORM}/obj
cp -r ${BENCH_DIR}/src/* ${BENCH_DIR}/build/${PLATFORM}/obj/

make -C ${BENCH_DIR}/build/${PLATFORM}/obj version=pthreads
make -C ${BENCH_DIR}/build/${PLATFORM}/obj install version=pthreads