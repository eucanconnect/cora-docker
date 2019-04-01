# Opal init container for Kubernetes
To bootstrap Opal with all the initial configuration you need to set a  number of properties:

- Configure databases
- Configure RServer 
- Configure DataSHIELD packages

## Usage
You can deploy this container besides your opal container. You need to set the following environment variables for a default installation:

- **Opal**
  ```bash
  OPAL_ADMINISTRATOR_PASSWORD={{ .Values.adminPassword }}
  ```

- **MongoDB**
  ```bash
  MONGODB_HOST={{ template "opal.fullname" . }}-mongodb
  ```

- **RServer**
  ```bash
  RSERVER_HOST={{ template "opal.fullname" . }}-rserver
  ```

>note: we do not use MySQL in a standard installation.

### Non standard installation
When you want to deploy your database instances in your deployment you can use the non-standard method.

- **Opal**
  ```bash
  OPAL_ADMINISTRATOR_PASSWORD={{ .Values.adminPassword }}
  ```
  
- **MongoDB**
  ```bash  
  MONGO_PORT_27017_TCP_ADDR={{ template "opal.fullname" . }}-mongodb
  MONGO_PORT_27017_TCP_PORT=
  ```
  
- **MySQL**
  ```bash
  MYSQLIDS_PORT_3306_TCP_PORT=
  MYSQLDATA_PORT_3306_TCP_ADDR=
  MYSQLIDS_PORT_3306_TCP_PORT=
  MYSQLDATA_PORT_3306_TCP_PORT=
  ```  