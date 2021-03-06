#!/usr/bin/env bash

# shell utilities

function build() {
    VERSION_DATA=`cat ${GOPATH}/src/github.com/TeaWeb/code/teaconst/const.go`
    VERSION_DATA=${VERSION_DATA#*"Version = \""}
    VERSION=${VERSION_DATA%%[!0-9.]*}
    TARGET=${GOPATH}/dist/teaweb-v${VERSION}

    echo "[================ building ${GOOS}/${GOARCH}/v${VERSION}] ================]"

    echo "[create target directory]"

    if [ -d ${TARGET} ]
    then
        rm -rf ${TARGET}
    fi

    mkdir ${TARGET}
    mkdir ${TARGET}/bin
    mkdir ${TARGET}/plugins
    mkdir ${TARGET}/tmp
    mkdir ${TARGET}/configs

    echo "[build static file]"
    go build -o ${TARGET}/bin/teaweb ${GOPATH}/src/github.com/TeaWeb/code/main/main.go

    echo "[copy files]"
    cp -R configs/admin.conf ${TARGET}/configs/
    cp -R configs/mongo.conf ${TARGET}/configs/
    cp -R configs/server.conf ${TARGET}/configs/

    cp -R public ${TARGET}/
    cp -R resources ${TARGET}/
    cp -R views ${TARGET}/

    echo "[zip files]"
    cd ${TARGET}/../
    zip -r -X -q teaweb-${GOOS}-${GOARCH}-v${VERSION}.zip  teaweb-v${VERSION}/
    cd -

    echo "[clean files]"
    rm -rf ${TARGET}

    echo "[done]"
}