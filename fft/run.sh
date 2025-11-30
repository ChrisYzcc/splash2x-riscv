BENCH_DIR="$(pwd)"
RUN_DIR=${BENCH_DIR}/build/${PLATFORM}/run

if [ ! -d "${RUN_DIR}" ]; then
    mkdir -p "${RUN_DIR}"
else
    rm -rf "${RUN_DIR}"/*
fi

case "${INPUT_SIZE}" in 
"test"	) 
	PROGARGS="-m18 -p${NTHREADS}";;
"simdev"	) 
	PROGARGS="-m18 -p${NTHREADS}";;
"simsmall"	) 
	PROGARGS="-m20 -p${NTHREADS}";;
"simmedium"	) 
	PROGARGS="-m22 -p${NTHREADS}";;
"simlarge"	) 
	PROGARGS="-m24 -p${NTHREADS}";;
"native"	) 
	PROGARGS="-m28 -p${NTHREADS}";;
*)  
	echo "Input size error"
	exit 1;;
esac

echo "Running fft..."
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/bin/fft ${PROGARGS}
cd ${BENCH_DIR}