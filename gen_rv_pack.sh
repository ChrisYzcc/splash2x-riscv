SPLASH2XDIR=$(pwd)

ALL="barnes cholesky fft fmm lu_cb lu_ncb ocean_cp ocean_ncp radiosity radix raytrace volrend water_nsquared water_spatial"

INPUTS="test"
USAGE="normal"

while getopts "i:u:h" opt; do
    case "$opt" in
        i) INPUTS=$OPTARG ;;
        u) USAGE=$OPTARG ;;
        h) echo "Usage: $0 [-i inputs] [-u usage] [-h]"
           echo "  -i inputs    : specify the inputs to package. Default: test"
           echo "  -u usage     : set usage: normal, profiling, checkpoint. Default: normal"
           echo "  -h           : display this help message"
           exit 0 ;;
    esac
done

if [ ! -d "${SPLASH2XDIR}/splash2x_rv_pack" ]; then
    mkdir -p ${SPLASH2XDIR}/splash2x_rv_pack
else
    rm -rf ${SPLASH2XDIR}/splash2x_rv_pack/*
fi

if [ "$USAGE" != "normal" ] && [ "$USAGE" != "profiling" ] && [ "$USAGE" != "checkpoint" ]; then
    echo "\033[31m[ERROR] Unknown usage mode: $USAGE\033[0m"
    exit 1
fi

# Support INPUTS: test, simdev, simsmall, simmedium, simlarge
INPUT_LIST=""
for INPUT in $(echo $INPUTS | tr ',' ' '); do
    case "$INPUT" in
        test) INPUT_LIST="${INPUT_LIST} test" ;;
        simdev) INPUT_LIST="${INPUT_LIST} simdev" ;;
        simsmall) INPUT_LIST="${INPUT_LIST} simsmall" ;;
        simmedium) INPUT_LIST="${INPUT_LIST} simmedium" ;;
        simlarge) INPUT_LIST="${INPUT_LIST} simlarge" ;;
        *)
            echo "\033[31m[ERROR] Unknown input set: $INPUT\033[0m"
            exit 1
            ;;
    esac
done


echo "==========================================================="
echo "  Input sets to package   : $INPUT_LIST"
echo "  Usage mode              : $USAGE"
echo "==========================================================="

for PROGRAM in $ALL; do
    mkdir -p ${SPLASH2XDIR}/splash2x_rv_pack/${PROGRAM}

    # Copy binaries
    mkdir -p ${SPLASH2XDIR}/splash2x_rv_pack/${PROGRAM}/build/rv64/${USAGE}
    cp -r ${SPLASH2XDIR}/${PROGRAM}/build/rv64/${USAGE}/bin ${SPLASH2XDIR}/splash2x_rv_pack/${PROGRAM}/build/rv64/${USAGE}/bin

    # Copy inputs and run script
    if [ -d "${SPLASH2XDIR}/${PROGRAM}/inputs" ]; then
        mkdir -p ${SPLASH2XDIR}/splash2x_rv_pack/${PROGRAM}/inputs
        for INPUT in $INPUT_LIST; do
            INPUT_TAR="input_${INPUT}.tar"
            if [ -f "${SPLASH2XDIR}/${PROGRAM}/inputs/${INPUT_TAR}" ]; then
                cp ${SPLASH2XDIR}/${PROGRAM}/inputs/${INPUT_TAR} ${SPLASH2XDIR}/splash2x_rv_pack/${PROGRAM}/inputs/${INPUT_TAR}
            else
                echo "\033[33m[WARNING] Input ${INPUT_TAR} does not exist for program ${PROGRAM}\033[0m"
            fi
        done
    fi

    cp -r ${SPLASH2XDIR}/${PROGRAM}/run.sh ${SPLASH2XDIR}/splash2x_rv_pack/${PROGRAM}/
done

echo "  Generating package completed."
echo "==========================================================="

cp -r ${SPLASH2XDIR}/run.sh ${SPLASH2XDIR}/splash2x_rv_pack/
sed -i 's|^\./run\.sh$|/bin/sh ./run.sh|' ${SPLASH2XDIR}/splash2x_rv_pack/run.sh