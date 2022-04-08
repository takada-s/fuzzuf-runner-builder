FROM ghcr.io/fuzzuf/fuzzuf/dev:latest

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# in 2022/03, GitHub-hosted runner works on Azure DSv2 series.
#   https://docs.github.com/ja/actions/using-github-hosted-runners/about-github-hosted-runners
#   https://docs.microsoft.com/ja-jp/azure/virtual-machines/dv2-dsv2-series#dsv2-series
# it provides haswell or newer CPU.
WORKDIR /work
RUN git clone https://github.com/fuzzuf/fuzzuf.git \
  && cd fuzzuf  \
  && cmake -B build -DCMAKE_BUILD_TYPE=Release -DRELEASE_MARCH=haswell \
  && cmake --build build -j$(nproc)

# AFL++
WORKDIR /work
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential python3-dev automake cmake git flex bison libglib2.0-dev libpixman-1-dev python3-setuptools \
    lld-11 llvm-11 llvm-11-dev clang-11 \
    gcc-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-plugin-dev libstdc++-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-dev
RUN git clone https://github.com/AFLplusplus/AFLplusplus \
  && cd AFLplusplus \
  && make all \
  && make install \
  && make deepclean \
  && apt-get clean \
  && rm -rf /var/lib/apt/litsts/*

CMD ["/bin/bash"]
