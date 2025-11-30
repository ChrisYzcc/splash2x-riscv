BENCH_DIR="$(pwd)"
RUN_DIR=${BENCH_DIR}/build/${PLATFORM}/run

if [ ! -d "${RUN_DIR}" ]; then
    mkdir -p "${RUN_DIR}"
else
    rm -rf "${RUN_DIR}"/*
fi

# Get input files
echo "Extracting input files ..."
tar -xvf ${BENCH_DIR}/inputs/input_${INPUT_SIZE}.tar -C ${RUN_DIR}
echo "Completed extracting input files."
echo

ARGS="-s -p${NTHREADS} teapot.env"

case "${INPUT_SIZE}" in 
"test"	) 
	PROGARGS="-s -p${NTHREADS} -a4 teapot.env";;
"simdev"	) 
	PROGARGS="-s -p${NTHREADS} -a4 teapot.env";;
"simsmall"	) 
	PROGARGS="-s -p${NTHREADS} -a8 teapot.env";;
"simmedium"	) 
	PROGARGS="-s -p${NTHREADS} -a2 balls4.env";;
"simlarge"	) 
	PROGARGS="-s -p${NTHREADS} -a8 balls4.env";;
"native"	) 
	PROGARGS="-s -p${NTHREADS} -a128 car.env";;
*)  
	echo "Input size error"
	exit 1;;
esac

echo "Running Raytrace..."
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/bin/raytrace ${PROGARGS}
cd ${BENCH_DIR}