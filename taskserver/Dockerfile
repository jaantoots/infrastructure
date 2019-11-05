FROM alpine:latest

# Install taskserver
RUN apk -U --no-progress upgrade && \
    apk -U --no-progress add taskd taskd-pki

# Set configuration
ARG TASKDDATA
ENV TASKDDATA ${TASKDDATA:-/var/lib/taskd}
ENV TASKD_ORGANIZATION Public
ENV TASKD_CN localhost
ENV TASKD_COUNTRY US
ENV TASKD_STATE California
ENV TASKD_LOCALITY San Francisco

# Add run script
RUN mkdir -p /opt/app
COPY run.sh /opt/app/

# Configure container
EXPOSE 53589
USER taskd
WORKDIR ${TASKDDATA}
VOLUME ["${TASKDDATA}"]
CMD ["/opt/app/run.sh"]
