cd "$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%x}}" )" >/dev/null 2>&1 && pwd )"
cd ..

export NEO4J_CONTAINER_ROOT=`pwd`/scratch
export NEO4J_DATA_DIR=`pwd`/scratch/data
export NEO4J_HEADER_DIR=`pwd`/headers
export NEO4J_VERSION=4.2.5
export NEO4J_ENV_VARS=""
export NEO4J_CSV_DIR=`pwd`/../data/csv-composite-projected-fk
export NEO4J_CONTAINER_NAME="neo-ldbc-data-test"
