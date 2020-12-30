set -x
java -jar __business-units/admin/target/admin-v0.1.jar &
sleep 1
echo $! > .pidfile
set +x
