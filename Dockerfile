FROM ubuntu:18.04

COPY . /nykk
WORKDIR /nykk

ENV PATH=/clang-7.0.0/bin:$PATH
ENV PATH=/root/.cargo/bin:$PATH
ENV LD_LIBRARY_PATH=/clang-7.0.0/lib:$LD_LIBRARY_PATH

RUN BUILD_DEPS='autoconf build-essential ca-certificates curl xz-utils' \
	&& apt-get update && apt-get install -y --no-install-recommends $BUILD_DEPS \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -SL http://releases.llvm.org/7.0.0/clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz | tar -xJC / \
	&& mv /clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-16.04 /clang-7.0.0 \
	&& curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable \
	&& curl -SL https://github.com/jemalloc/jemalloc/archive/5.1.0.tar.gz | tar -xzC / \
	&& cd /jemalloc-5.1.0 \
	&& ./autogen.sh \
	&& make \
	&& mv lib/libjemalloc.a /usr/local/lib/libjemalloc.a \
	&& cd - \
	&& rm -rf /jemalloc-5.1.0 \
	&& make \
	&& rm /usr/local/lib/libjemalloc.a \
	&& rustup self uninstall -y \
	&& rm -rf /clang-7.0.0 \
	&& apt-get purge -y --auto-remove $BUILD_DEPS

CMD [ "/bin/bash" ]
