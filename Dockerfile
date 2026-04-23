FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.TinyTeX/bin/x86_64-linux:$PATH"

# system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    perl curl ca-certificates libfontconfig1 fonts-font-awesome xz-utils gnupg \
    && rm -rf /var/lib/apt/lists/*

# install TinyTeX
RUN curl -sL https://yihui.org/tinytex/install-bin-unix.sh | sh

# set CTAN repo + install ONLY required addons
RUN /root/.TinyTeX/bin/x86_64-linux/tlmgr option repository https://mirror.ctan.org/systems/texlive/tlnet \
    && /root/.TinyTeX/bin/x86_64-linux/tlmgr update --self --all \
    && /root/.TinyTeX/bin/x86_64-linux/tlmgr install \
        fontawesome5 \
        blindtext \
        lua-uni-algos \
        xstring \
        fancyhdr

# copy system files
COPY entrypoint.sh /entrypoint.sh
COPY validate.sh /validate.sh
COPY latex.lock /latex.lock

RUN chmod +x /entrypoint.sh /validate.sh

ENTRYPOINT ["/entrypoint.sh"]