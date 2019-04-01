FROM python:2.7.9

ENV OPAL_PYTHON_CLIENT_VERSION=2.10.12

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

RUN wget https://github.com/obiba/opal/releases/download/${OPAL_PYTHON_CLIENT_VERSION}/opal-python-client-${OPAL_PYTHON_CLIENT_VERSION}.tar.gz
RUN tar -xvzf opal-python-client-${OPAL_PYTHON_CLIENT_VERSION}.tar.gz
RUN cd opal-python-client-${OPAL_PYTHON_CLIENT_VERSION} && python setup.py install --record installed_files.lst

RUN mkdir -p /opt/opal/data/dictionary

COPY data/scripts/* /opt/opal/bin/

COPY data/*.json /opt/opal/data/
COPY data/dictionary/*.csv /opt/opal/data/dictionary/

RUN chmod +x -R /opt/opal/bin/

COPY ./docker-entrypoint.bash /
RUN chmod +x /docker-entrypoint.bash

ENTRYPOINT ["/docker-entrypoint.bash"]





