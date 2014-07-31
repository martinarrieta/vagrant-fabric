#!/bin/bash
# script to destroy everything without the need for vagrant destroy
# takes only one option argument which is --force, to skip the confirmation prompt. 

confirmation()
{
echo "This will destroy the datadir on all nodes and teardown Fabric's store. Do you want to continue? (y/N)  (you can skip this prompt by using the --force option)" >&2
read confirmation
[ "$confirmation" == "y" ] && return 0 || return 1
}

force=0
[ "$1" == "--force" ] && force=1
if [ $force == 0 ]; then
    confirmation || exit
fi

trap "rm -f commands.$$" SIGINT SIGTERM

cat>commands.$$ <<EOF
mysqlfabric manage stop 2>/dev/null
mysqlfabric manage teardown
mysqlfabric manage setup
nohup mysqlfabric manage start &

EOF

vagrant ssh store -c "$(cat commands.$$)"

for i in 1 2 3; do
    cat >commands.$$ <<EOF
set -x
sudo service mysqld stop
sudo service mysqld2 stop
sudo rm -rf /var/lib/mysql/
sudo rm -rf /var/lib/mysql2
sudo mkdir /var/lib/mysql/
sudo mkdir /var/lib/mysql2
sudo mysql_install_db --defaults-file=/etc/my.cnf
sudo mysql_install_db --defaults-file=/etc/my2.cnf
sudo chown -R mysql.mysql /var/lib/mysql
sudo chown -R mysql.mysql /var/lib/mysql2
sudo service mysqld start
sudo service mysqld2 start
mysql -vv -h127.0.0.1 -P3306 -uroot -e 'grant all on *.* to fabric@"%"; grant all on *.* to fabric@"%";'
mysql -vv -h127.0.0.1 -P3306 -uroot -e 'grant all on *.* to fabric@localhost; grant all on *.* to fabric@"%";'
mysql -vv -h127.0.0.1 -P13306 -uroot -e 'grant all on *.* to fabric@"%"; grant all on *.* to fabric@"%";'
mysql -vv -h127.0.0.1 -P13306 -uroot -e 'grant all on *.* to fabric@localhost; grant all on *.* to fabric@"%";'
EOF
    vagrant ssh node$i -c "$(cat commands.$$)"

done

	sleep 2

for i in 1 2 3; do
    for port in 3306 13306; do
	vagrant ssh node$i -c "mysql -h127.0.0.1 -P$port -uroot -e 'reset master'"
    done
done


rm -f commands.$$

exit 0
