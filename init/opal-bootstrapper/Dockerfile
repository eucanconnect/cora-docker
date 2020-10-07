FROM python:3.5.10-slim-stretch

ENV OPAL_PYTHON_CLIENT_VERSION=3.1.2

ENV OPAL_ADMINISTRATOR_PASSWORD=opal

ENV OPAL_HOST=localhost
ENV RSERVER_HOST=localhost

ENV MONGODB_ENABLED=true
ENV MONGODB_HOST=localhost
ENV MONGO_PORT_27017_TCP_ADDR=localhost
ENV MONGO_PORT_27017_TCP_PORT=27017

ENV MYSQL_ENABLED=false
ENV MYSQLIDS_PORT_3306_TCP_ADDR=localhost
ENV MYSQLIDS_PORT_3306_TCP_PORT=3306

ENV MYSQLDATA_PORT_3306_TCP_ADDR=localhost
ENV MYSQLDATA_PORT_3306_TCP_PORT=3306

RUN apt-get update && apt-get install wget libcurl4-openssl-dev libssl-dev libblas-dev libatlas-base-dev -y
RUN wget https://github.com/obiba/opal-python-client/releases/download/${OPAL_PYTHON_CLIENT_VERSION}/opal-python-client-${OPAL_PYTHON_CLIENT_VERSION}.tar.gz
RUN tar -xvzf opal-python-client-${OPAL_PYTHON_CLIENT_VERSION}.tar.gz
COPY opal-python-client/ez_setup.py opal-python-client-${OPAL_PYTHON_CLIENT_VERSION}
RUN cd opal-python-client-${OPAL_PYTHON_CLIENT_VERSION} && python setup.py install --record installed_files.lst

RUN mkdir -p /opt/opal/bin/
RUN mkdir -p /opt/opal/config/

COPY scripts/backend/* /opt/opal/bin/
COPY scripts/datashield/* /opt/opal/bin/

COPY config/*.json /opt/opal/config/

RUN chmod +x -R /opt/opal/bin/

COPY ./docker-entrypoint.bash /
RUN chmod +x /docker-entrypoint.bash

ENTRYPOINT ["/docker-entrypoint.bash"]





