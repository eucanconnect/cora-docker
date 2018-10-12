FROM rocker/rstudio

RUN apt-get update
RUN apt-get install -y libgsl0-dev

# Install Opal packages
RUN R -e "install.packages('opal', repos=c(getOption('repos'), 'http://cran.obiba.org'), dependencies=TRUE)"
# Install DataSHIELD packages
RUN R -e "install.packages('datashieldclient', repos=c(getOption('repos'), 'http://cran.obiba.org'), dependencies=TRUE)"