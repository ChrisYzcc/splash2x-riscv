BENCH_DIR="$(pwd)"
RUN_DIR=${BENCH_DIR}/build/${PLATFORM}/run

if [ ! -d "${RUN_DIR}" ]; then
    mkdir -p "${RUN_DIR}"
else
    rm -rf "${RUN_DIR}"/*
fi

case "${INPUT_SIZE}" in 
"test"	) 
	PROGARGS="-p${NTHREADS} -r4096 -n262144 -m524288";;
"simdev"	) 
	PROGARGS="-p${NTHREADS} -r4096 -n262144 -m524288";;
"simsmall"	) 
	PROGARGS="-p${NTHREADS} -r4096 -n4194304 -m2147483647";;
"simmedium"	) 
	PROGARGS="-p${NTHREADS} -r4096 -n16777216 -m2147483647";;
"simlarge"	) 
	PROGARGS="-p${NTHREADS} -r4096 -n67108864 -m2147483647";;
"native"	) 
	PROGARGS="-p${NTHREADS} -r4096 -n268435456 -m2147483647";;
*)  
	echo "Input size error"
	exit 1;;
esac

echo "Running radix..."
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/${USAGE}/bin/radix ${PROGARGS}
cd ${BENCH_DIR}