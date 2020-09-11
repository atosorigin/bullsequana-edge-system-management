FILENAME=""
PWD="mismpass"
USER="mism"
VERBOSE=""
CONTAINER="pgadmin"
TARGET="awx"
DB="mism"

usage()
{
  echo "Usage: $0 [-v(verbose)] [-t target (awx*/zabbix)] [-u user] -f dump_file"
  echo "the dump_file must be under [INSTALL_DIR]/pgadmin/pgadmin_bullsequana.com/ directory"
  exit 2
}

{
  echo "Usage: $0 [-v(verbose)] -f filename "
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

echo "TARGET=$TARGET"
echo "FILENAME=$FILENAME"
echo "USER=$USER"

if [[ -z  ${FILENAME} ]];then
	usage
fi

if [ ${TARGET} = "awx" ]
then
    HOST="awx_postgres"
fi

if [ ${TARGET} = "zabbix" ]
then
    HOST="zabbix-postgres"
fi

echo "HOST=$HOST"

docker exec -e PGPASSWORD=${PWD} ${CONTAINER} /usr/local/pgsql-12/pg_restore --host -h ${HOST} --port "5432" --username=${USER} --dbname $DB -c ${VERBOSE} "/var/lib/pgadmin/storage/pgadmin_bullsequana.com/${FILENAME}"

if [ $? -ne 0 ]; then
    echo ">> Database restore failed !!!"
else
    echo ">> The Database is restored !"
fi
