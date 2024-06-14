##################
### PocketBase ###
##################


# docs      :   https://pocketbase.io/docs
# refrence  :   https://pocketbase.io/docs/going-to-production/#using-docker

FROM alpine:latest as base

ARG PB_VERSION=0.22.13
WORKDIR /temp

# Install Packages & pull latest binary
RUN echo "Installing packages...";\
        apk add --no-cache \
            wget \
            unzip \
            ca-certificates; \
    \
    echo "Getting pocketbase...";\
        wget https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip; \
        unzip pocketbase_${PB_VERSION}_linux_amd64.zip -d pb;

# pocketbase binary is now at /temp/pb/pocketbase


#####
## PocketBase Runtime
#####

FROM alpine:latest as runtime

ARG APP_ROOT=/app
ARG DEFAULT_USER=pocketbase

# copy pocketbase binary
COPY --from=base --chown=1000:1000 /temp/pb/pocketbase  ${APP_ROOT}/pocketbase

# setup default user and pocketbase binary
RUN mkdir -p ${APP_ROOT}; cd ${APP_ROOT}; \
    addgroup -g 1000 ${DEFAULT_USER}; \
    adduser -D -G ${DEFAULT_USER} -g ${DEFAULT_USER} -s /bin/ash ${DEFAULT_USER} -h ${APP_ROOT};\
    chmod +x ${APP_ROOT}/pocketbase


USER ${DEFAULT_USER}

WORKDIR ${APP_ROOT}


###
## run: server
###

# Docker pocketbase server port [default: 8090]
EXPOSE 80

CMD [ "./pocketbase", "serve", "--http=0.0.0.0:80" ]