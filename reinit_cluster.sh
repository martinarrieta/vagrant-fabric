#!/bin/bash
# script to destroy everything without the need for vagrant destroy
# takes only one option argument which is --force, to skip the confirmation prompt. 

confirmation()
{
echo "This will destroy the datadir on all nodes and teardown Fabric's store. Do you want to continue? (y/N)  (you can skip this prompt by using the --force option)" >&2
read confirmation
return [ "$confirmation" == "y" ] && return 0 || return 1
}

force=0
[ "$1" == "--force" ] && force=1
if [ $force == 0 ]; then
    confirmation || exit
fi

cat | vagrant ssh store <<EOF

mysqlfabric manage teardown

EOF

for i in 1 2 3; do
    cat | vagrant ssh node$i <<EOF

sudo service mysqld stop
sudo rm -rf /var/lib/mysql/
sudo mkdir /var/lib/mysql/
sudo mysql_install_db
sudo chown -R mysql.mysql /var/lib/mysql
sudo service mysqld start

EOF
done

exit 0
