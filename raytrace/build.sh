BENCH_DIR="$(pwd)"

export CFLAGS="${CFLAGS} -Wl,--allow-multiple-definition"

mkdir -p ${BENCH_DIR}/build/${PLATFORM}/obj
cp -r ${BENCH_DIR}/src/* ${BENCH_DIR}/build/${PLATFORM}/obj/

make -C ${BENCH_DIR}/build/${PLATFORM}/obj
make -C ${BENCH_DIR}/build/${PLATFORM}/obj install