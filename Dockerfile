# vim: sw=2 ts=2 et

# Start with the Restic container
FROM ghcr.io/restic/restic:0.17.3 as restic

# Our actual container will be based off of Alpine
FROM alpine:latest

# Copy static files into the container:
COPY root/ /

# Install some packages that Restic will want
RUN apk add --no-cache ca-certificates fuse openssh-client tzdata jq

# Install Bash & MariaDB
RUN apk add --no-cache bash mariadb-client

# Restic is a single binary; copy it to our container
COPY --from=restic /usr/bin/restic /usr/bin/restic

# All done!
ENTRYPOINT ["/entry.sh"]
