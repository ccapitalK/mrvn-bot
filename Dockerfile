FROM rust:buster as builder
RUN apt-get update && apt-get install -y cmake
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/download/2023.03.04/yt-dlp_linux -o /usr/local/bin/youtube-dl && chmod a+rx /usr/local/bin/youtube-dl
WORKDIR /usr/src/mrvn-bot
COPY . .
RUN cargo install --path ./mrvn-front-discord

FROM bitnami/minideb:buster
RUN apt-get update && apt-get install -y ca-certificates libopus0 libopus-dev python && rm -rf /var/lib/apt/lists/*
RUN update-ca-certificates
COPY --from=builder /usr/local/cargo/bin/mrvn-front-discord /usr/local/bin/mrvn-front-discord
CMD ["myapp"]
