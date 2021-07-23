FROM alpine:latest as builder
WORKDIR /server
RUN apk add --update alpine-sdk linux-headers git zlib-dev openssl-dev gperf cmake
RUN git clone --recursive https://github.com/tdlib/telegram-bot-api.git
RUN mkdir ./telegram-bot-api/build
RUN cd ./telegram-bot-api/build && \
  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=.. ..
RUN cd ./telegram-bot-api/build && \
  cmake --build . --target install
FROM alpine:latest
RUN apk add --update openssl libstdc++
COPY --from=builder /server/telegram-bot-api/bin/telegram-bot-api /telegram-bot-api
CMD /telegram-bot-api --http-port 7116 --local

