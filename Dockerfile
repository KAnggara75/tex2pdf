FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.TinyTeX/bin/x86_64-linux:/root/.TinyTeX/bin/aarch64-linux:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    perl curl ca-certificates libfontconfig1 fonts-font-awesome xz-utils gnupg \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://yihui.org/tinytex/install-bin-unix.sh | sh

# DEBUG (hapus kalau sudah stabil)
RUN ls -R /root/.TinyTeX/bin || true

# install packages WITHOUT hardcoded path
RUN tlmgr option repository https://mirror.ctan.org/systems/texlive/tlnet \
    && tlmgr install parskip geometry xcolor xstring fancyhdr ragged2e hyperref fontawesome5 blindtext

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]