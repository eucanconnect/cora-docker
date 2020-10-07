

## Login as superuser
Navigate to localhost
Login with;

username: "cn=admin,dc=ldap,dc=molgenis,dc=org" --> based upon the domain and prefixed with cn=admin
password: admin --> based upon the env var in the docker-compose

## Adding a user
Create a POSIX group first
Then create a Generic user and select the POSIX group

## Configuring the RStudio with LDAP

https://computingforgeeks.com/how-to-configure-ubuntu-18-04-ubuntu-16-04-lts-as-ldap-client/
https://jstaf.github.io/2018/06/20/rstudio-server-semi-pro.html

Install: 
```bash
apt-get update --fix-missing
apt-get install -y libnss-ldap libpam-ldap ldap-utils
```

answers:
```bash
LDAP URI:                     ldap://ldap
Search base:                  dc=ldap,dc=molgenis,dc=org
LDAP version:                 3
Behave like local root:       yes
Require login:                no
LDAP administrative account:  cn=admin,dc=ldap,dc=molgenis,dc=org
LDAP administrative password: admin
LDAP root account:            cn=admin,dc=ldap,dc=molgenis,dc=org
LDAP root password:           admin  
```


By client, I mean the machine, which connects to LDAP server to get users and authorize. It can be also the machine, the LDAP server runs on. In both cases we have to edit three files : 
- /etc/nsswitch.conf
- /etc/pam.d/rstudio (for authentication in rstudio)
- /etc/pam.d/common-auth (for user-directory creation)

Let's confgure the `nsswitch.conf` now:
 
```bash
passwd: compat ldap
group:  compat ldap
shadow: files ldap
gshadow: files
```

Let's confgure the `rstudio` by deleting the following line:
```bash
#%PAM-1.0
auth       sufficient     pam_ldap.so
account    required       pam_ldap.so
session    requisite      pam_ldap.so
```

Last but not least the `common-auth` configuration. Add the following line:
```bash
# create homedir on LDAP login
session required pam_mkhomedir.so skel=/etc/skel/ umask=0022
```

Test the LDAP configuration by executing the following command: `ldapsearch -H ldap://ldap -x -D "cn=admin,dc=ldap,dc=molgenis,dc=org" -W`

Check supported SASL mechanisms: `ldapsearch -H ldap://ldap -x -b "" -s base -LLL supportedSASLMechanisms`

This is what RStudio tries to do: `ldapsearch -H ldap://ldap base="dc=ldap,dc=molgenis,dc=org" scope=2 deref=0 filter="(uid=shaakma)"`