# RStudio

RStudio instance for Docker and Kubernetes

> note: see [Rocker GitHub](https://github.com/rocker-org/rocker/wiki/Using-the-RStudio-image)

To start the docker please type:

```docker run -d -p 8787:8787 -e PASSWORD=admin -e USER=admin #container#```

## DataSHIELD

You need to install 2 R-packages to make you of DataSHIELD in RStudio.
- Opal
- DataSHIELD client

## LDAP

You can configure the LDAP instance by setting the following configuration.
```bash

```

## Persistence
You need to mount the following container path.
- /home

 