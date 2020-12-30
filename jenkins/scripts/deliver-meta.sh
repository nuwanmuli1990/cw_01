set -x
java -jar __business-units/__meta-new/meta-new-all/target/meta-new-all-v0.1.jar &
sleep 1
echo $! > .pidfile
set +x
