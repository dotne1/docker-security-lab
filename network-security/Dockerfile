FROM alpine:latest

RUN apk add --no-cache iptables ip6tables

COPY enforce-isolation.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/enforce-isolation.sh

CMD ["/usr/local/bin/enforce-isolation.sh"]

