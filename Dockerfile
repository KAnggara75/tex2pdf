FROM alpine:3.19

WORKDIR /var/local

# combine into one run command to reduce image size
RUN apk update && apk add perl wget fontconfig font-awesome-free && curl -sL "https://yihui.org/tinytex/install-bin-unix.sh" | sh && apk clean
ENV PATH="${PATH}:/root/bin"

RUN tlmgr update --self --all
RUN tlmgr path add
RUN fmtutil-sys --all

WORKDIR /

COPY . /

ENTRYPOINT ["/entrypoint.sh"]