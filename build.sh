export SPLASH2XDIR=$(pwd)

PLATFORM=native
PROGRAM=barnes

ALL="barnes cholesky fft fmm lu_cb lu_ncb ocean_cp ocean_ncp radiosity radix raytrace volrend water_nsquared water_spatial"

while getopts "p:rh" opt; do
    case "$opt" in
        p) PROGRAM=$OPTARG ;;
        r) PLATFORM=rv64 ;;
        h) echo "Usage: $0 [-p program] [-r] [-h]"
           echo "  -p program : specify the program to build, default: blackscholes"
           echo "  -r          : set platform to rv64"
           echo "  -h          : display this help message"
           exit 0 ;;
    esac
done

# Arguments to use
export CFLAGS=" -O3 -g -funroll-loops ${PORTABILITY_FLAGS} -static"
export CXXFLAGS="-O3 -g -funroll-loops -fpermissive -fno-exceptions ${PORTABILITY_FLAGS} -std=c++98 -static"
export CPPFLAGS=""
export CXXCPPFLAGS=""
export LDFLAGS="-L${CC_HOME}/lib64 -L${CC_HOME}/lib -no-pie -static"
export LIBS=""
export EXTRA_LIBS=""

# RISC-V Cross Compile Prefix
if [ "$PLATFORM" = "rv64" ]; then
    CROSS_COMPILE_PREFIX=riscv64-linux-gnu-
else
    CROSS_COMPILE_PREFIX=
fi

# Compilers and preprocessors
CC_HOME=/usr/bin
export CC="${CC_HOME}/${CROSS_COMPILE_PREFIX}gcc"
export CXX="${CC_HOME}/${CROSS_COMPILE_PREFIX}g++"
export CPP="${CC_HOME}/${CROSS_COMPILE_PREFIX}cpp"

# GNU Binutils
BINUTIL_HOME=/usr/bin
export LD="${BINUTIL_HOME}/${CROSS_COMPILE_PREFIX}ld"
export NM="${BINUTIL_HOME}/${CROSS_COMPILE_PREFIX}nm"
export STRIP="${BINUTIL_HOME}/${CROSS_COMPILE_PREFIX}strip"
export AR="${CC_HOME}/${CROSS_COMPILE_PREFIX}ar"
export RANLIB="${CC_HOME}/${CROSS_COMPILE_PREFIX}ranlib"

# GNU Tools
export M4=/usr/bin/m4
export MAKE=/usr/bin/make

export PLATFORM
export VERSION

if [ "${PROGRAM}" = "all" ]; then


    FAILED_LIST=""
    for prog in $ALL; do
        echo "============================================================================"
        echo "  Building Target : ${prog}"
        echo "  Platform        : ${PLATFORM}"
        echo "============================================================================"
        cd ${prog}
        ./build.sh
        if [ $? -ne 0 ]; then
            echo -e "\033[31m[ERROR] Build failed for ${prog}!\033[0m"
            FAILED_LIST="$FAILED_LIST $prog"
        fi
        cd ${SPLASH2XDIR}
    done

    echo "============================================================================"
    echo "  Build of all programs completed."
    echo "============================================================================"
    if [ -n "$FAILED_LIST" ]; then
        echo -e "\033[31m[ERROR] The following programs failed to build:$FAILED_LIST\033[0m"
        exit 1
    fi
    exit 0
else
    echo "============================================================================"
    echo "  Building Target : ${PROGRAM}"
    echo "  Platform        : ${PLATFORM}"
    echo "============================================================================"


    cd ${PROGRAM}
    ./build.sh
    if [ $? -ne 0 ]; then
        echo -e "\033[31m[ERROR] Build failed for ${PROGRAM}!\033[0m"
        cd ${SPLASH2XDIR}
        exit 1
    fi
    cd ${SPLASH2XDIR}

    echo "============================================================================"
    echo "  Build of ${PROGRAM} completed."
    echo "============================================================================"
fi