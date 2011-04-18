pushd ../db && mvn clean install && popd && mvn -Dorg.apache.cocoon.logging=debug $1 $2 $3 $4
