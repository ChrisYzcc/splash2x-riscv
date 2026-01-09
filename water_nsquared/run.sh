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

# Generate input file
INPUT_FILE="${RUN_DIR}/input"
INPUT_TEMPLATE="${RUN_DIR}/input.template"
echo "Generating input file ${INPUT_FILE} ..."
cat ${INPUT_TEMPLATE} | sed s/NUMPROCS/$NTHREADS/ > ${INPUT_FILE}
echo

echo "Running water_nsquared..."
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/${USAGE}/bin/water_nsquared ${NTHREADS} < ${INPUT_FILE}
cd ${BENCH_DIR}