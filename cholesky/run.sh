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
	INPUTFILE="${RUN_DIR}/tk14.O";;
"simdev"	) 
	INPUTFILE="${RUN_DIR}/tk14.O";;
"simsmall"	) 
	INPUTFILE="${RUN_DIR}/tk29.O";;
"simmedium"	) 
	INPUTFILE="${RUN_DIR}/tk29.O";;
"simlarge"	) 
	INPUTFILE="${RUN_DIR}/tk29.O";;
"native"	) 
	INPUTFILE="${RUN_DIR}/tk29.O";;
*)  
	echo "Input size error"
	exit 1;;
esac

echo "Running Cholesky..."
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/bin/cholesky -p${NTHREADS} < ${INPUTFILE}
cd ${BENCH_DIR}