FROM alpine:3.17 as build
WORKDIR /home
RUN apk add --no-cache git tzdata go
RUN git clone https://github.com/betauia/Beetroot.git
WORKDIR ./Beetroot/cmd/beetroot
RUN go get
RUN CGO_ENABLED=0 go build -o main .



FROM alpine:3.17 as runtime
WORKDIR /
RUN apk add -U tzdata
ENV TZ=America/New_York
RUN cp /usr/share/zoneinfo/America/New_York /etc/localtime
COPY --from=build home/Beetroot/cmd/beetroot .
CMD ./main
