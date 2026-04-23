FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.TinyTeX/bin/x86_64-linux:$PATH"

# system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    perl curl ca-certificates libfontconfig1 fonts-font-awesome xz-utils gnupg \
    && rm -rf /var/lib/apt/lists/*

# install TinyTeX
RUN curl -sL https://yihui.org/tinytex/install-bin-unix.sh | sh

# set CTAN repo + install all required packages
RUN /root/.TinyTeX/bin/x86_64-linux/tlmgr option repository https://mirror.ctan.org/systems/texlive/tlnet \
    && /root/.TinyTeX/bin/x86_64-linux/tlmgr install \
        amsmath amsfonts fontawesome5 blindtext lua-uni-algos \
        xstring fancyhdr ragged2e fontenc geometry hyperref xcolor multicol parskip

# copy system files
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]