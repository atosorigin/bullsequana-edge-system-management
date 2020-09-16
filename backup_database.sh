FILENAME=""
PASSWORD="mismpass"
VERBOSE=""
CONTAINER="pgadmin"
BASEDIR=$(dirname $0)
USER="mism"
DB=""

usage()
{
  echo "Usage: $0 [-v(verbose)] [-u user] -t target (awx*/zabbix) -f filename"
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

if [ -z ${TARGET} ]
then
    usage
fi

if [ -z ${USER} ]
then
    usage
fi


if [ ${TARGET} != "awx" -a  ${TARGET} != "zabbix" ]
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

export DEST_DIR="storage/pgadmin_bullsequana.com"

if [ ! -d $DEST_DIR ]
then
    mkdir -p $DEST_DIR
fi

docker exec -e PGPASSWORD=${PASSWORD} ${CONTAINER} /usr/local/pgsql-12/pg_dump -f "/var/lib/pgadmin/storage/pgadmin_bullsequana.com/$FILENAME" --host ${HOST} --port "5432" --username=${USER} ${VERBOSE} --format=c --clean --column-inserts $DB

if [ $? -ne 0 ]
then
    echo ">> Database dump failed !!!"
    exit -1
fi

if [ ! -f $DEST_DIR/$FILENAME ]    
then
    
    echo -e "\e[101m>> Database dump not generated in $DEST_DIR/$FILENAME !!!\e[0m"
    exit -1
fi

echo -e "\e[42m>> The Database dump is saved under $BASEDIR/$DEST_DIR/${FILENAME}\e[0m"

