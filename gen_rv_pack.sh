SPLASH2XDIR=$(pwd)

ALL="barnes cholesky fft fmm lu_cb lu_ncb ocean_cp ocean_ncp radiosity radix raytrace volrend water_nsquared water_spatial"

if [ ! -d "${SPLASH2XDIR}/splash2x_rv_pack" ]; then
    mkdir -p ${SPLASH2XDIR}/splash2x_rv_pack
else
    rm -rf ${SPLASH2XDIR}/splash2x_rv_pack/*
fi

for PROGRAM in $ALL; do
    mkdir -p ${SPLASH2XDIR}/splash2x_rv_pack/${PROGRAM}

    mkdir -p ${SPLASH2XDIR}/splash2x_rv_pack/${PROGRAM}/build/rv64
    cp -r ${SPLASH2XDIR}/${PROGRAM}/build/rv64/bin ${SPLASH2XDIR}/splash2x_rv_pack/${PROGRAM}/build/rv64/bin
    if [ -d "${SPLASH2XDIR}/${PROGRAM}/inputs" ]; then
        cp -r ${SPLASH2XDIR}/${PROGRAM}/inputs ${SPLASH2XDIR}/splash2x_rv_pack/${PROGRAM}/inputs
    fi
    cp -r ${SPLASH2XDIR}/${PROGRAM}/run.sh ${SPLASH2XDIR}/splash2x_rv_pack/${PROGRAM}/
done

cp -r ${SPLASH2XDIR}/run.sh ${SPLASH2XDIR}/splash2x_rv_pack/