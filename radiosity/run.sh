BENCH_DIR="$(pwd)"
RUN_DIR=${BENCH_DIR}/build/${PLATFORM}/run

if [ ! -d "${RUN_DIR}" ]; then
    mkdir -p "${RUN_DIR}"
else
    rm -rf "${RUN_DIR}"/*
fi

case "${INPUT_SIZE}" in 
"test"	) 
	PROGARGS="-bf 1.5e-1 -batch -room -p ${NTHREADS}";;
"simdev"	) 
	PROGARGS="-bf 1.5e-1 -batch -room -p ${NTHREADS}";;
"simsmall"	) 
	PROGARGS="-bf 1.5e-1 -batch -room -p ${NTHREADS}";;
"simmedium"	) 
	PROGARGS="-bf 1.5e-2 -batch -room -p ${NTHREADS}";;
"simlarge"	) 
	PROGARGS="-bf 1.5e-3 -batch -room -p ${NTHREADS}";;
"native"	) 
	PROGARGS="-bf 1.5e-4 -batch -largeroom -p ${NTHREADS}";;
*)  
	echo "Input size error"
	exit 1;;
esac

echo "Running radiosity..."
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/${USAGE}/bin/radiosity ${PROGARGS}
cd ${BENCH_DIR}