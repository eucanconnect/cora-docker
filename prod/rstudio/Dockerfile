FROM rocker/rstudio:4.0.1

ENV USERS=

RUN apt-get update
RUN apt-get install -y libgsl0-dev zlib1g-dev libxml2-dev

# Install Opal packages
RUN R -e "install.packages('DSOpal', dependencies=TRUE)"
# Install Opal administrator packages
RUN R -e "install.packages('DSMolgenisArmadillo', repos=c(getOption('repos'), 'http://registry.molgenis.org/repository/R'), dependencies=TRUE)"
# Install DataSHIELD packages
RUN R -e "install.packages('dsBaseClient', repos=c(getOption('repos'), 'http://cran.obiba.org'), dependencies=TRUE)"

COPY scripts/bootstrap.bash /

CMD ["/bootstrap.bash"]