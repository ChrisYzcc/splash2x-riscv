export SPLASH2XDIR=$(pwd)

PLATFORM=native
PROGRAM=barnes
ENABLE_CHECKPOINT=false

ALL="barnes cholesky fft fmm lu_cb lu_ncb ocean_cp ocean_ncp radiosity radix raytrace volrend water_nsquared water_spatial"

USAGE="normal"

while getopts "p:ru:h" opt; do
    case "$opt" in
        p) PROGRAM=$OPTARG ;;
        r) PLATFORM=rv64 ;;
        u) USAGE=$OPTARG ;;
        h) echo "Usage: $0 [-p program] [-r] [-h] [-u usage]"
           echo "  -p program   : specify the program to build. Default: barnes"
           echo "  -r           : set platform to rv64"
           echo "  -u           : set usage: normal, profiling, checkpoint. Default: normal"
           echo "  -h           : display this help message"
           exit 0 ;;
    esac
done

# Arguments to use
export CFLAGS=" -O3 -g -funroll-loops ${PORTABILITY_FLAGS}"
export CXXFLAGS="-O3 -g -funroll-loops -fpermissive -fno-exceptions ${PORTABILITY_FLAGS} -std=c++98"
export CPPFLAGS=""
export CXXCPPFLAGS=""
export LDFLAGS="-L${CC_HOME}/lib64 -L${CC_HOME}/lib -no-pie"
export LIBS=""
export EXTRA_LIBS=""

USE_STATIC=yes
if [ "$USE_STATIC" = "yes" ]; then
    export CFLAGS="${CFLAGS} -static"
    export CXXFLAGS="${CXXCPPFLAGS} -static"
    export LDFLAGS="${LDFLAGS} -static"
fi

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

# Check usage mode
if [ "$USAGE" = "checkpoint" ]; then
    ENABLE_CHECKPOINT=true
elif [ "$USAGE" = "profiling" ]; then
    ENABLE_CHECKPOINT=true
    export CFLAGS="${CFLAGS} -DENABLE_PROFILING"
    export CXXFLAGS="${CXXFLAGS} -DENABLE_PROFILING"
elif [ "$USAGE" != "normal" ]; then
    echo "\033[31m[ERROR] Unknown usage mode: $USAGE\033[0m"
    exit 1
fi

export USAGE

# Build parsec_hook for checkpoint
if [ "${ENABLE_CHECKPOINT}" = "true" ]; then
    echo "============================================================================"
    echo "  Building Target : parsec_hooks (FOR CHECKPOINTING AND PROFILING)"
    echo "  Platform        : ${PLATFORM}"
    echo "============================================================================"

    if [ "${PLATFORM}" = "rv64" ]; then
        export CFLAGS="${CFLAGS} -DNEMU"
        export CXXFLAGS="${CXXFLAGS} -DNEMU"
    fi

    if [ ! -d "${SPLASH2XDIR}/parsec_hooks/build/${PLATFORM}/${USAGE}/lib" ]; then
        mkdir -p ${SPLASH2XDIR}/parsec_hooks/build/${PLATFORM}/${USAGE}/obj
        cp -r ${SPLASH2XDIR}/parsec_hooks/src/* ${SPLASH2XDIR}/parsec_hooks/build/${PLATFORM}/${USAGE}/obj
        make -C ${SPLASH2XDIR}/parsec_hooks/build/${PLATFORM}/${USAGE}/obj
        make -C ${SPLASH2XDIR}/parsec_hooks/build/${PLATFORM}/${USAGE}/obj install

        if [ $? -ne 0 ]; then
            echo "\033[31m[ERROR] Build failed for parsec_hooks!\033[0m"
            exit 1
        fi
    else
        echo "  parsec_hooks already built for ${PLATFORM}, ${USAGE}, skipping."
    fi

    export CFLAGS="${CFLAGS} -I${SPLASH2XDIR}/parsec_hooks/build/${PLATFORM}/${USAGE}/include -DENABLE_PARSEC_HOOKS"
    export CXXFLAGS="${CXXFLAGS} -I${SPLASH2XDIR}/parsec_hooks/build/${PLATFORM}/${USAGE}/include -DENABLE_PARSEC_HOOKS"
    export LDFLAGS="${LDFLAGS} -L${SPLASH2XDIR}/parsec_hooks/build/${PLATFORM}/${USAGE}/lib -lhooks"

    echo "============================================================================"
    echo
fi

if [ "${PROGRAM}" = "all" ]; then
    FAILED_LIST=""
    for prog in $ALL; do
        echo "============================================================================"
        echo "  Building Target : ${prog}"
        echo "  Platform        : ${PLATFORM}"
        echo "  USAGE           : ${USAGE}"
        echo "============================================================================"
        cd ${prog}
        ./build.sh
        if [ $? -ne 0 ]; then
            echo "\033[31m[ERROR] Build failed for ${prog}!\033[0m"
            FAILED_LIST="$FAILED_LIST $prog"
        fi
        cd ${SPLASH2XDIR}
    done

    echo "============================================================================"
    echo "  Build of all programs completed."
    echo "============================================================================"
    if [ -n "$FAILED_LIST" ]; then
        echo "\033[31m[ERROR] The following programs failed to build:$FAILED_LIST\033[0m"
        exit 1
    fi
    exit 0
else
    echo "============================================================================"
    echo "  Building Target : ${PROGRAM}"
    echo "  Platform        : ${PLATFORM}"
    echo "  USAGE           : ${USAGE}"
    echo "============================================================================"


    cd ${PROGRAM}
    ./build.sh
    if [ $? -ne 0 ]; then
        echo "\033[31m[ERROR] Build failed for ${PROGRAM}!\033[0m"
        cd ..
        exit 1
    fi
    cd ${SPLASH2XDIR}

    echo "============================================================================"
    echo "  Build of ${PROGRAM} completed."
    echo "============================================================================"
fi