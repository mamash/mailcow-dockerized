#!/bin/bash

if [ -z "$1" ]; then
  cat <<EOF

Usage:

  $0 <createdb|mysql|import> [dbname]

EOF
  exit 1
fi

cmd=${1}
db=${2}
base_dir=$(cd $(dirname $0)/..; pwd)
. ${base_dir}/.env

case ${cmd} in
  createdb)
    [ -z "${db}" ] || (\
      docker-compose exec mysql-mailcow mysql -p${DBROOT} -e "create database ${db} character set utf8 collate utf8_general_ci"
      docker-compose exec mysql-mailcow mysql -p${DBROOT} -e "grant all privileges on ${db}.* to ${DBUSER}@'%' identified by '${pass}'"
      docker-compose exec mysql-mailcow mysql -p${DBROOT} -e "flush privileges")
    ;;
  mysql)
    docker-compose exec mysql-mailcow mysql -u${DBUSER} -p${DBPASS} ${DBNAME}
    ;;
  import)
    docker-compose exec -T mysql-mailcow mysql -u${DBUSER} -p${DBPASS} ${DBNAME}
    ;;
esac
