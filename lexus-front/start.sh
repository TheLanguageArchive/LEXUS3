export MVN_OPTS='-Xmx3072m -Xms2048m'
export JAVA_OPTS='-Xmx3072m -Xms2048m'
mvn -Dorg.apache.cocoon.log4j.loglevel=$1 -Dorg.apache.cocoon.mode=$2 $3 $4
#/usr/share/maven/bin/mvnDebug -Dorg.apache.cocoon.log4j.loglevel=$1 -Dorg.apache.cocoon.mode=$2 $3 $4
