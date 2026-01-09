#!/bin/sh
PLATFORM=native
PROGRAM=barnes
NTHREADS=1
INPUT_SIZE="test"
USAGE="normal"

while getopts "p:rhn:u:i:" opt; do
    case "$opt" in
        p) PROGRAM=$OPTARG ;;
        r) PLATFORM=rv64 ;;
        n) NTHREADS=$OPTARG ;;
        u) USAGE=$OPTARG ;;
        i) INPUT_SIZE=$OPTARG ;;
        h) echo "Usage: $0 [-p program] [-r] [-v version] [-i input] [-n threads] [-u usage] [-h]"
           echo "  -p program   : specify the program to run, default: barnes"
           echo "  -r           : set platform to rv64"
           echo "  -n threads   : specify the number of threads, default: 1"
           echo "  -u usage     : set usage: normal, profiling, checkpoint. default: normal \\n \
                    normal: normal execution; \\n \
                    profiling: for profiling; \\n \
                    checkpoint: for checkpointing."
           echo "  -i input     : specify the input size, default: test"
           echo "  -h           : display this help message"
           exit 0 ;;
    esac
done

# Check USAGE mode
if [ "$USAGE" != "normal" ] && [ "$USAGE" != "profiling" ] && [ "$USAGE" != "checkpoint" ]; then
    echo "\033[31m[ERROR] Unknown usage mode: $USAGE\033[0m"
    exit 1
fi

export PLATFORM
export NTHREADS
export INPUT_SIZE
export USAGE

echo "============================================================================"
echo "  Running Target  : ${PROGRAM}"
echo "  Threads         : ${NTHREADS}"
echo "  Platform        : ${PLATFORM}"
echo "  Input Size      : ${INPUT_SIZE}"
echo "  USAGE           : ${USAGE}"
echo "============================================================================"

cd ${PROGRAM}
./run.sh
cd ..

echo "============================================================================"
echo "  Finished Running Target : ${PROGRAM}"
echo "============================================================================"