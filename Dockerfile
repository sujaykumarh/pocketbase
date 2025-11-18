##################
### PocketBase ###
##################


# docs      :   https://pocketbase.io/docs
# refrence  :   https://pocketbase.io/docs/going-to-production/#using-docker

FROM --platform=$BUILDPLATFORM alpine:latest AS base

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG PB_VERSION=0.33.0
# ARG PB_PLATFORM=amd64

WORKDIR /temp

# Install Packages & pull latest binary
RUN export PLATFORM=`basename $TARGETPLATFORM`; \
    \
    echo "Installing packages...";\
        apk add --no-cache \
            wget \
            unzip \
            ca-certificates; \
    \
    echo "Getting pocketbase...";\
        wget https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_${PLATFORM}.zip; \
        unzip pocketbase_${PB_VERSION}_linux_${PLATFORM}.zip -d pb;

# pocketbase binary is now at /temp/pb/pocketbase


#####
## PocketBase Runtime
#####

FROM alpine:latest AS runtime

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
