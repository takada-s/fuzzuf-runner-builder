FROM ghcr.io/fuzzuf/fuzzuf/dev:latest

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq afl++-clang \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /work
RUN git clone https://github.com/fuzzuf/fuzzuf.git \
  && cd fuzzuf  \
  && cmake -B build -DCMAKE_BUILD_TYPE=Release \
  && cmake --build build -j$(nproc)

CMD ["/bin/bash"]
