.DEFAULT_GOAL := all

BUILD_TYPE := release

ROOT := $(realpath ${PWD})
CD   := $(realpath ${CURDIR})

BIN_DIR := ${ROOT}/bin/${BUILD_TYPE}${CD:${ROOT}%=%}
OBJ_DIR := ${ROOT}/obj/${BUILD_TYPE}${CD:${ROOT}%=%}

.PHONY: all test clean

clean::
	${RM} -r ${BIN_DIR} ${OBJ_DIR}
