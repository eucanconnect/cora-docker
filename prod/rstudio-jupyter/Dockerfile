FROM jupyter/r-notebook:95ccda3619d0

RUN python3 -m pip install jupyter-rsession-proxy
RUN python3 -m pip install jupyter-server-proxy
RUN jupyter labextension install @jupyterlab/server-proxy

# install rstudio-server
USER root
RUN apt-get update && \ 
    apt-get install -y libgsl0-dev zlib1g-dev libxml2-dev && \
    curl --silent -L --fail https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.3.959-amd64.deb > /tmp/rstudio.deb && \
    apt-get install -y /tmp/rstudio.deb && \
    rm /tmp/rstudio.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Opal packages
RUN R -e "install.packages('DSOpal', repos = 'https://cran.r-project.org', dependencies=TRUE)"
# Install Opal administrator packages
RUN R -e "install.packages('DSMolgenisArmadillo', repos=c('https://cran.r-project.org', 'http://registry.molgenis.org/repository/R'), dependencies=TRUE)"
# Install DataSHIELD packages
RUN R -e "install.packages('dsBaseClient', repos=c('https://cran.r-project.org', 'http://cran.obiba.org'), dependencies=TRUE)"

ENV PATH=$PATH:/usr/lib/rstudio-server/bin
USER $NB_USER

# disable login
CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize", "0", "--auth-none", "1"]