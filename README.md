#### Nomad Variables Demo

### Setup

Run `vagrant up` this will deploy a local VM and the 1.4 beta version of Nomad.

### Deploy some secure variables

Browse to the new variables page UI at `http://localhost:4646/ui/variables`

We can also do this via the CLI
```
# Set the address (this is the default but you may have it set elsewhere)
export NOMAD_ADDR=http://localhost:4646

# Do we have any variables?
nomad var list

# Lets set some


nomad var put nomad/jobs/mysql-server \
    MYSQL_USER=wordpress \
    MYSQL_PASSWORD=highlysecurepassword \
    MYSQL_DATABASE=wordpress \
    MYSQL_RANDOM_ROOT_PASSWORD=1

# And run the mysql job

nomad job run jobs/mysql.nomad
```

### Time for something to use our database

```
nomad var put nomad/jobs/wordpress \
    WORDPRESS_DB_NAME=wordpress \
    WORDPRESS_DB_USER=wordpress \
    WORDPRESS_DB_PASSWORD=highlysecurepassword

nomad job run jobs/wordpress.nomad
```




