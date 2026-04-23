FROM debian:bookworm-slim

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
# Add TinyTeX to PATH
ENV PATH="/root/.TinyTeX/bin/x86_64-linux:/root/.TinyTeX/bin/aarch64-linux:${PATH}"

# Combine setup steps to reduce layers and image size
RUN apt-get update
RUN apt-get install -y --no-install-recommends perl curl ca-certificates libfontconfig1 fonts-font-awesome xz-utils gnupg
RUN curl -sL "https://yihui.org/tinytex/install-bin-unix.sh" | sh
# Set a reliable mirror and update
RUN /root/.TinyTeX/bin/*/tlmgr option repository http://mirror.ctan.org/systems/texlive/tlnet
RUN /root/.TinyTeX/bin/*/tlmgr update --self --all
RUN /root/.TinyTeX/bin/*/tlmgr install xetex luatex
RUN /root/.TinyTeX/bin/*/tlmgr path add
RUN fmtutil-sys --all
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Copy only necessary files
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]