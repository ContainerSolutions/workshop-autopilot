# a Node.js application container including Containerbuddy
FROM gliderlabs/alpine:3.3

# install curl
RUN apk update && apk add \
    nodejs \
    curl \
    && rm -rf /var/cache/apk/*

# install the Express.js dependency
COPY package.json /opt/customers/
RUN cd /opt/customers && npm install

# get Containerbuddy release
RUN export CB=containerbuddy-0.1.1 &&\
   curl -Lo /tmp/${CB}.tar.gz \
   https://github.com/joyent/containerbuddy/releases/download/0.1.1/${CB}.tar.gz && \
   tar -xz -f /tmp/${CB}.tar.gz && \
   mv /containerbuddy /bin/

# add our application
COPY customers.js /opt/customers/

# add Containerbuddy configuration
COPY containerbuddy.json /etc/containerbuddy.json
ENV CONTAINERBUDDY=file:///etc/containerbuddy.json

EXPOSE 4000
CMD [ "/bin/containerbuddy", \
      "node", \
      "/opt/customers/customers.js" \
]
