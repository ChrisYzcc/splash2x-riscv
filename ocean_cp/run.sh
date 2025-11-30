BENCH_DIR="$(pwd)"
RUN_DIR=${BENCH_DIR}/build/${PLATFORM}/run

if [ ! -d "${RUN_DIR}" ]; then
    mkdir -p "${RUN_DIR}"
else
    rm -rf "${RUN_DIR}"/*
fi

case "${INPUT_SIZE}" in
"test"	) 
	PROGARGS="-n258 -p$NTHREADS -e1e-07 -r20000 -t28800";;
"simdev"	) 
	PROGARGS="-n258 -p$NTHREADS -e1e-07 -r20000 -t28800";;
"simsmall"	) 
	PROGARGS="-n514 -p$NTHREADS -e1e-07 -r20000 -t28800";;
"simmedium"	) 
	PROGARGS="-n1026 -p$NTHREADS -e1e-07 -r20000 -t28800";;
"simlarge"	) 
	PROGARGS="-n2050 -p$NTHREADS -e1e-07 -r20000 -t28800";;
"native"	) 
	PROGARGS="-n4098 -p$NTHREADS -e1e-07 -r10000 -t14400";;
*)  
	echo "Input size error"
	exit 1;;
esac

echo "Running ocean_cp..."
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/bin/ocean_cp ${PROGARGS}
cd ${BENCH_DIR}