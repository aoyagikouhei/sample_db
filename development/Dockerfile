FROM rust:1.75

RUN apt -y update && apt -y install musl-tools libssl-dev pkg-config build-essential

RUN rustup update && \
  cargo install cargo-watch && \
  rustup component add rustfmt clippy
