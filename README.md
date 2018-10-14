# RStudio

RStudio instance for Docker and Kubernetes

> note: see [Rocker GitHub](https://github.com/rocker-org/rocker/wiki/Using-the-RStudio-image)

To start the docker please type:

```docker run -d -p 8787:8787 -e PASSWORD=admin -e USER=admin #containerId#```

## DataSHIELD
You need to install 2 R-packages to make you of DataSHIELD in RStudio.
- Opal
- DataSHIELD client

## Authentication
There a number of supported mechanisms here. We support at this moment 2 of them.
- LDAP
- Third party authentication

## LDAP
You can configure the LDAP instance by setting the following configuration. you have to use the PAM-authentication to introduce LDAP to RStudio.
```bash
/etc/pam.d/rstudio.conf
```

## Third party authentication



## Persistence
You need to mount the following container path. You need to map the home directory to persist user data.
- /home

 