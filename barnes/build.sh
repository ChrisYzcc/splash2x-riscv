BENCH_DIR=${SPLASH2XDIR}/barnes

mkdir -p ${BENCH_DIR}/build/${PLATFORM}/${USAGE}/obj
cp -r ${BENCH_DIR}/src/* ${BENCH_DIR}/build/${PLATFORM}/${USAGE}/obj/

make -C ${BENCH_DIR}/build/${PLATFORM}/${USAGE}/obj version=pthreads
make -C ${BENCH_DIR}/build/${PLATFORM}/${USAGE}/obj install version=pthreads