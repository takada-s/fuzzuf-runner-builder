FROM ghcr.io/fuzzuf/fuzzuf/dev:latest

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq afl++-clang \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# in 2022/03, GitHub-hosted runner works on Azure DSv2 series.
#   https://docs.github.com/ja/actions/using-github-hosted-runners/about-github-hosted-runners
#   https://docs.microsoft.com/ja-jp/azure/virtual-machines/dv2-dsv2-series#dsv2-series
# it provides haswell or newer CPU.
WORKDIR /work
RUN git clone https://github.com/fuzzuf/fuzzuf.git \
  && cd fuzzuf  \
  && sed -i.bak 's/-march=native/-march=haswell/g' CMakeLists.txt \
  && cmake -B build -DCMAKE_BUILD_TYPE=Release \
  && cmake --build build -j$(nproc)

CMD ["/bin/bash"]
