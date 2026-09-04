FROM ubuntu:24.04 AS build
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    cmake \
    g++ \
    make \
    libboost-program-options-dev \
    libfmt-dev \
  && rm -rf /var/lib/apt/lists/*
WORKDIR /src
COPY . .
RUN cmake -S . -B build -DCMAKE_BUILD_TYPE=Release \
  && cmake --build build -j8 \
  && install -D build/Champollion/Champollion /out/Champollion

FROM ubuntu:24.04
RUN apt-get update \
  && apt-get install -y --no-install-recommends libboost-program-options1.83.0 libfmt9 \
  && rm -rf /var/lib/apt/lists/*
COPY --from=build /out/Champollion /usr/local/bin/Champollion
ENTRYPOINT ["Champollion"]
