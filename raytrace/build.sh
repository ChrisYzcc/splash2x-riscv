BENCH_DIR="$(pwd)"

mkdir -p ${BENCH_DIR}/build/${PLATFORM}/${USAGE}/obj
cp -r ${BENCH_DIR}/src/* ${BENCH_DIR}/build/${PLATFORM}/${USAGE}/obj/

make -C ${BENCH_DIR}/build/${PLATFORM}/${USAGE}/obj
make -C ${BENCH_DIR}/build/${PLATFORM}/${USAGE}/obj install