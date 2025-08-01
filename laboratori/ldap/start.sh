docker stop openldap
docker stop mariadb-galera
docker stop mariadb-client
docker stop openldap
docker rm openldap
docker rm mariadb-galera
docker rm mariadb-client
docker network rm my-network

docker network create my-network --driver bridge

docker run --detach -it --rm --name openldap \
  --network my-network \
  --env LDAP_ADMIN_USERNAME=admin \
  --env LDAP_ADMIN_PASSWORD=adminpassword \
  --env LDAP_USERS=customuser \
  --env LDAP_PASSWORDS=custompassword \
  --env LDAP_ROOT=dc=example,dc=org \
  --env LDAP_ADMIN_DN=cn=admin,dc=example,dc=org \
  bitnami/openldap:latest

docker run --detach --rm --name mariadb-galera \
    --network my-network \
    --env MARIADB_ROOT_PASSWORD=root-password \
    --env MARIADB_GALERA_MARIABACKUP_PASSWORD=backup-password \
    --env MARIADB_USER=customuser \
    --env MARIADB_DATABASE=customdatabase \
    --env MARIADB_ENABLE_LDAP=yes \
    --env LDAP_URI=ldap://openldap:1389 \
    --env LDAP_BASE=dc=example,dc=org \
    --env LDAP_BIND_DN=cn=admin,dc=example,dc=org \
    --env LDAP_BIND_PASSWORD=adminpassword \
    bitnami/mariadb-galera:latest

docker run -it --rm --name mariadb-client \
    --network my-network \
    bitnami/mariadb-galera:latest mysql -h mariadb-galera -u customuser -D customdatabase -pcustompassword
