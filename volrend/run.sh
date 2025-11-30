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

case "${INPUT_SIZE}" in 
"test"	) 
	PROGARGS="${NTHREADS} head-scaleddown4 4";;
"simdev"	) 
	PROGARGS="${NTHREADS} head-scaleddown4 4";;
"simsmall"	) 
	PROGARGS="${NTHREADS} head-scaleddown4 20";;
"simmedium"	) 
	PROGARGS="${NTHREADS} head-scaleddown2 50";;
"simlarge"	) 
	PROGARGS="${NTHREADS} head-scaleddown2 100";;
"native"	) 
	PROGARGS="${NTHREADS} head 1000";;
*)  
	echo "Input size error"
	exit 1;;
esac

echo "Running Volrend..."
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/bin/volrend ${PROGARGS}
cd ${BENCH_DIR}