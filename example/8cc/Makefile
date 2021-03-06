include ../../common.mk

WATERMARK := 77

CC := clang

CFLAGS := \
	-DBUILD_DIR="\"$$PWD/8cc\""

CFLAGS_debug := -O0
CFLAGS_release := -O2 -DNDEBUG
CFLAGS += ${CFLAGS_${BUILD_TYPE}}

8CCFLAGS := \
	-DBUILD_DIR="\"$$PWD/8cc\""

8CCFLAGS_debug :=
8CCFLAGS_release := -DNDEBUG
8CCFLAGS += ${8CCFLAGS_${BUILD_TYPE}}

LDFLAGS := \
	-no-pie

SRCS := \
	8cc/buffer.c \
	8cc/cpp.c \
	8cc/debug.c \
	8cc/dict.c \
	8cc/encoding.c \
	8cc/error.c \
	8cc/file.c \
	8cc/gen.c \
	8cc/lex.c \
	8cc/main.c \
	8cc/map.c \
	8cc/parse.c \
	8cc/path.c \
	8cc/set.c \
	8cc/vector.c

.PHONY: all test clean

all: stage3 stage3-wm

stage3: ${BIN_DIR}/stage3/8cc.out
stage2: ${BIN_DIR}/stage2/8cc.out
stage1: ${BIN_DIR}/stage1/8cc.out

stage3-wm: ${BIN_DIR}/stage3-wm/8cc.out
stage2-wm: ${BIN_DIR}/stage2-wm/8cc.out
stage1-wm: ${BIN_DIR}/stage1-wm/8cc.out

${BIN_DIR}/stage1/8cc.out: ${SRCS:8cc/%.c=${OBJ_DIR}/stage1/%.o}
${BIN_DIR}/stage2/8cc.out: ${SRCS:8cc/%.c=${OBJ_DIR}/stage2/%.o}
${BIN_DIR}/stage3/8cc.out: ${SRCS:8cc/%.c=${OBJ_DIR}/stage3/%.o}

${BIN_DIR}/stage1-wm/8cc.out: ${SRCS:8cc/%.c=${OBJ_DIR}/stage1-wm/%.o}
${BIN_DIR}/stage2-wm/8cc.out: ${SRCS:8cc/%.c=${OBJ_DIR}/stage2-wm/%.o}
${BIN_DIR}/stage3-wm/8cc.out: ${SRCS:8cc/%.c=${OBJ_DIR}/stage3-wm/%.o}

# Normal 8cc.
${OBJ_DIR}/stage1/%.o: 8cc/%.c
	@mkdir -p ${@D}
	${CC} ${CFLAGS} -o $@ -c $<

${OBJ_DIR}/stage2/%.o: 8cc/%.c ${BIN_DIR}/stage1/8cc.out
	@mkdir -p ${@D}
	${BIN_DIR}/stage1/8cc.out -w ${8CCFLAGS} -o $@ -c $<

${OBJ_DIR}/stage3/%.o: 8cc/%.c ${BIN_DIR}/stage2/8cc.out
	@mkdir -p ${@D}
	${BIN_DIR}/stage2/8cc.out -w ${8CCFLAGS} -o $@ -c $<

# Watermarked 8cc
${OBJ_DIR}/stage1-wm/%.o: 8cc/%.c
	@mkdir -p ${@D}
	clang ${CFLAGS} -S -emit-llvm -o ${@:%.o=%.ll} $<
	opt -load=${ROOT}/bin/${BUILD_TYPE}/src/nykk.so -block-wm -watermark=${WATERMARK} -S -o ${@:%.o=%-block-wm.ll} ${@:%.o=%.ll} 2> ${@:%.o=%-block-wm.txt}
	opt -load=${ROOT}/bin/${BUILD_TYPE}/src/nykk.so -inst-wm -watermark=${WATERMARK} -S -o ${@:%.o=%-inst-wm.ll} ${@:%.o=%-block-wm.ll} 2> ${@:%.o=%-inst-wm.txt}
	opt -load=${ROOT}/bin/${BUILD_TYPE}/src/nykk.so -func-wm -watermark=${WATERMARK} -S -o ${@:%.o=%-func-wm.ll} ${@:%.o=%-inst-wm.ll} 2> ${@:%.o=%-func-wm.txt}
	clang ${CFLAGS} -o $@ -c ${@:%.o=%-func-wm.ll}

${OBJ_DIR}/stage2-wm/%.o: 8cc/%.c ${BIN_DIR}/stage1-wm/8cc.out
	@mkdir -p ${@D}
	${BIN_DIR}/stage1-wm/8cc.out -w ${8CCFLAGS} -o $@ -c $<

${OBJ_DIR}/stage3-wm/%.o: 8cc/%.c ${BIN_DIR}/stage2-wm/8cc.out
	@mkdir -p ${@D}
	${BIN_DIR}/stage2-wm/8cc.out -w ${8CCFLAGS} -o $@ -c $<

%.out:
	@mkdir -p ${@D}
	${CC} ${CFLAGS} -o $@ $^ ${LDFLAGS}

test: stage3 stage3-wm
	objdump -D -M intel ${BIN_DIR}/stage1/8cc.out > ${BIN_DIR}/stage1/8cc.s
	objdump -D -M intel ${BIN_DIR}/stage2/8cc.out > ${BIN_DIR}/stage2/8cc.s
	objdump -D -M intel ${BIN_DIR}/stage3/8cc.out > ${BIN_DIR}/stage3/8cc.s
	objdump -D -M intel ${BIN_DIR}/stage1-wm/8cc.out > ${BIN_DIR}/stage1-wm/8cc.s
	objdump -D -M intel ${BIN_DIR}/stage2-wm/8cc.out > ${BIN_DIR}/stage2-wm/8cc.s
	objdump -D -M intel ${BIN_DIR}/stage3-wm/8cc.out > ${BIN_DIR}/stage3-wm/8cc.s
