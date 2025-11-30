BENCH_DIR="$(pwd)"
RUN_DIR=${BENCH_DIR}/build/${PLATFORM}/run

if [ ! -d "${RUN_DIR}" ]; then
    mkdir -p "${RUN_DIR}"
else
    rm -rf "${RUN_DIR}"/*
fi

case "${INPUT_SIZE}" in 
"test"	) 
	PROGARGS="-p$NTHREADS -n512 -b16";;
"simdev"	) 
	PROGARGS="-p$NTHREADS -n512 -b16";;
"simsmall"	) 
	PROGARGS="-p$NTHREADS -n512 -b16";;
"simmedium"	) 
	PROGARGS="-p$NTHREADS -n1024 -b16";;
"simlarge"	) 
	PROGARGS="-p$NTHREADS -n2048 -b16";;
"native"	) 
	PROGARGS="-p$NTHREADS -n8096 -b32";;
*)  
	echo "Input size error"
	exit 1;;
esac

echo "Running lu_ncb..."
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/bin/lu_ncb ${PROGARGS}
cd ${BENCH_DIR}