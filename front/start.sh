export MVN_OPTS=-Xmx=3036m
mvn -Dorg.apache.cocoon.log4j.loglevel=$1 -Dorg.apache.cocoon.mode=$2 $3 $4
