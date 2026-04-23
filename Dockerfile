FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.TinyTeX/bin/x86_64-linux:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    perl curl ca-certificates libfontconfig1 fonts-font-awesome xz-utils gnupg \
    && curl -sL https://yihui.org/tinytex/install-bin-unix.sh | sh \
    && /root/.TinyTeX/bin/x86_64-linux/tlmgr --version

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]