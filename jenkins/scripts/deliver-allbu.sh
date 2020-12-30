set -x
java -jar __business-units/_all/target/_all-v0.1.jar &
sleep 1
echo $! > .pidfile
set +x
