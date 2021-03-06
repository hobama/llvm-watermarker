include ${PWD}/common.mk

LLVM_INCLUDE_DIRS := $(shell llvm-config --includedir)

CXXFLAGS := \
	-std=c++17 \
	-Wall \
	-Wextra \
	-pedantic \
	-Werror \
	-Wno-unused-parameter \
	$(addprefix -I, $(shell llvm-config --includedir)) \
	-fPIC \
	-fno-rtti

CXXFLAGS_debug := -O0
CXXFLAGS_release := -O2 -DNDEBUG
CXXFLAGS += ${CXXFLAGS_${BUILD_TYPE}}

OBJS := ${SRCS:%.cpp=${OBJ_DIR}/%.o}
DEPS := ${OBJS:.o=.d}

all: ${BIN_DIR}/${TARGET}

test: ${BIN_DIR}/${TARGET}

${BIN_DIR}/${TARGET}: ${OBJS}

%.so:
	@mkdir -p ${@D}
	${CXX} ${CXXFLAGS} -shared -o $@ $^ ${LDFLAGS}

%.out:
	@mkdir -p ${@D}
	${CXX} ${CXXFLAGS} -o $@ $^ ${LDFLAGS}

${OBJ_DIR}/%.o: %.cpp
	@mkdir -p ${@D}
	${CXX} ${CXXFLAGS} -MMD -MP -o $@ -c $<

-include ${DEPS}
