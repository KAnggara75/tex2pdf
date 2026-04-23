FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.TinyTeX/bin/x86_64-linux:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    perl curl ca-certificates libfontconfig1 fonts-font-awesome xz-utils gnupg \
    && curl -sL "https://yihui.org/tinytex/install-bin-unix.sh" | sh \
    && /root/.TinyTeX/bin/*/tlmgr option repository https://mirror.ctan.org/systems/texlive/tlnet \
    && /root/.TinyTeX/bin/*/tlmgr update --self --all \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD []