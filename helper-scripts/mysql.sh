#!/bin/bash

if [ -z "$1" ]; then
  cat <<EOF

Usage:

  $0 <mysql|import>

EOF
  exit 1
fi

cmd=${1}
base_dir=$(cd $(dirname $0)/..; pwd)
. ${base_dir}/.env

case ${cmd} in
  mysql)
    docker-compose exec mysql-mailcow mysql -u${DBUSER} -p${DBPASS} ${DBNAME}
    ;;
  import)
    docker-compose exec -T mysql-mailcow mysql -u${DBUSER} -p${DBPASS} ${DBNAME}
    ;;
esac
