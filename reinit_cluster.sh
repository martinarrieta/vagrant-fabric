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

cat>commands.$$ <<EOF
mysqlfabric manage stop 2>/dev/null
mysqlfabric manage teardown
mysqlfabric manage setup
sudo mysqlfabric manage start --daemon

EOF

vagrant ssh store -c "$(cat commands.$$)"

for i in 1 2 3; do
    cat >commands.$$ <<EOF

sudo service mysqld stop
sudo rm -rf /var/lib/mysql/
sudo mkdir /var/lib/mysql/
sudo mysql_install_db --defaults-file=/etc/my.cnf
sudo chown -R mysql.mysql /var/lib/mysql
sudo service mysqld start
mysql -uroot -e 'set @@session.sql_log_bin=0;grant SUPER on *.* to fabric@"%" identified by "f4bric"; grant ALL on *.* to fabric@"%";stop slave;reset slave all;reset master;'

EOF
    vagrant ssh node$i -c "$(cat commands.$$)"

done

rm -f commands.$$

exit 0
