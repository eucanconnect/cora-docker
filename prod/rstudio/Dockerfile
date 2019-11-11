FROM rocker/rstudio:3.6.1

RUN apt-get update
RUN apt-get install -y libgsl0-dev zlib1g-dev libxml2-dev

# Install devtools for development
RUN R -e "install.packages('devtools')"
# Install Opal packages
RUN R -e "install.packages('opal', repos=c(getOption('repos'), 'http://cran.obiba.org'), dependencies=TRUE)"
# Install Opal administrator packages
RUN R -e "install.packages('opaladmin', repos=c(getOption('repos'), 'http://cran.obiba.org'), dependencies=TRUE)"
# Install DataSHIELD packages
RUN R -e "install.packages('datashieldclient', repos=c(getOption('repos'), 'http://cran.obiba.org'), dependencies=TRUE)"
