FILENAME=""
PWD="mismpass"
USER="mism"
VERBOSE=""
CONTAINER="pgadmin"
TARGET="awx"
DB="mism"

usage()
{
  echo "Usage: $0 [-v(verbose)] [-u user] -t target (awx*/zabbix) -f dump_file"
  echo "the dump_file must be under [INSTALL_DIR]/storage/pgadmin_bullsequana.com/ directory"
  exit 2
}

while getopts "vu:t:f:" option; do
    case "${option}" in

        v)
            VERBOSE="--verbose"
            ;;
        f)
            FILENAME=${OPTARG}
            ;;
        u)
            USER=${OPTARG}
            ;;
        t)
            TARGET=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

if [ -z ${FILENAME} ]
then
    usage
fi

if [ ${TARGET} = "awx" ]
then
    HOST="awx_postgres"
    DB="mism"
fi

if [ ${TARGET} = "zabbix" ]
then
    HOST="zabbix-postgres"
    DB="zabbix"
fi

docker exec -e PGPASSWORD=${PWD} ${CONTAINER} /usr/local/pgsql-12/pg_restore --host ${HOST} --port "5432" --username=${USER} --dbname $DB -c ${VERBOSE} "/var/lib/pgadmin/storage/pgadmin_bullsequana.com/${FILENAME}"

if [ $? -ne 0 ]; then
    echo -e "\e[101m>> The database restore failed !!! \e[0m"
    exit -1
fi

echo -e "\e[42m>> The database is restored ! \e[0m"


