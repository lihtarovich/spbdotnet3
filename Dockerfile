FROM mcr.microsoft.com/dotnet/sdk:3.1-alpine AS build

ARG dbhost=localhost
ARG dbport=5432
ARG UID=1001

WORKDIR /source

RUN apk update && apk upgrade && \
    apk add --no-cache bash git 
    
# download project and restore as distinct layers
RUN git clone https://github.com/lihtarovich/spbdotnet3 /source
RUN dotnet restore -r linux-musl-x64
RUN dotnet publish --runtime linux-musl-x64 -c Release -o /usr/bin/spbdotnet3/ --self-contained true --no-restore -p:PublishTrimmed=True -p:PublishReadyToRun=true SpbDotNetCore3

# final stage/image
FROM mcr.microsoft.com/dotnet/runtime-deps:3.1-alpine

ARG dbhost=localhost
ARG dbport=5432
ARG UID=1001

WORKDIR /usr/bin/spbdotnet3
COPY --from=build /usr/bin/spbdotnet3 ./

RUN echo DBHOST: $dbhost, DBPORT: $dbport
#RUN mkdir -p /usr/bin/spbdotnet3/
RUN mkdir -p /var/log/spbdo

RUN sed -i "s/Host=localhost/Host='$dbhost'/" /usr/bin/spbdotnet3/appsettings.json \
        && sed -i "s/Port=5432/Port=$dbport/" /usr/bin/spbdotnet3/appsettings.json

RUN addgroup -g $UID spbdotnet3 \
        && adduser -G spbdotnet3 -u $UID spbdotnet3 -D \
        && chown -R spbdotnet3:spbdotnet3 /usr/bin/spbdotnet3/ \
        && chmod -R 500 /usr/bin/spbdotnet3/ \
        && chown -R spbdotnet3:spbdotnet3 /var/log/spbdotnet3/ \
        && chmod -R 777 /usr/bin/spbdotnet3/spbdotnet.pfx
        
USER spbdotnet3

# See: https://github.com/dotnet/announcements/issues/20
# Uncomment to enable globalization APIs (or delete)
#ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false
#RUN apk add --no-cache icu-libs
#ENV LC_ALL=en_US.UTF-8
#ENV LANG=en_US.UTF-8

# Add VOLUMEs to allow logs
#VOLUME  ["/var/log/spbdotnet3/"]

EXPOSE 5003/tcp

ENTRYPOINT ["/usr/bin/spbdotnet3/SpbDotNetCore3"]
