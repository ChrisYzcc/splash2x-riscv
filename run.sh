PLATFORM=native
PROGRAM=barnes
NTHREADS=1
INPUT_SIZE=test

while getopts "p:rhn:i:" opt; do
    case "$opt" in
        p) PROGRAM=$OPTARG ;;
        r) PLATFORM=rv64 ;;
        n) NTHREADS=$OPTARG ;;
        h) echo "Usage: $0 [-p program] [-r] [-v version] [-h]"
           echo "  -p program   : specify the program to run, default: blackscholes"
           echo "  -r           : set platform to rv64"
           echo "  -n threads   : specify the number of threads, default: 1"
           echo "  -i input     : specify the input size, default: test"
           echo "  -h           : display this help message"
           exit 0 ;;
    esac
done

export PLATFORM
export NTHREADS
export INPUT_SIZE

echo "============================================================================"
echo "  Running Target  : ${PROGRAM}"
echo "  Threads         : ${NTHREADS}"
echo "  Input Size      : ${INPUT_SIZE}"
echo "============================================================================"

cd ${PROGRAM}
./run.sh
cd ..

echo "============================================================================"
echo "  Finished Running Target : ${PROGRAM}"
echo "============================================================================"