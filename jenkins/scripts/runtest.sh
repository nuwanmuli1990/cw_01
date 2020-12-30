set -x
java -jar target/demo-0.0.1-SNAPSHOT.jar &
sleep 1
echo $! > .pidfile
set +x
