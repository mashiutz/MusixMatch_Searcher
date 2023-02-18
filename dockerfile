# pull alpine image
 FROM alpine:latest

# add powershell from alpine package repo
RUN apk add --no-cache powershell

# copy Pode module and API server files
COPY ./APIScripts /usr/src/app/
COPY ./Pode /usr/local/share/powershell/Modules/Pode

EXPOSE 8088

# run the server
ENTRYPOINT [ "pwsh"]
CMD [ "-c", "cd /usr/src/app; ./server.ps1" ]