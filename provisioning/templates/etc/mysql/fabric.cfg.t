[DEFAULT]
prefix                          = /usr
sysconfdir                      = /etc
logdir                          = /var/log

[servers]
user                            = fabric

[storage]
address                         = localhost:3306 
user                            = store 
password                        = f4bric 
database                        = fabric 
connection_timeout              = 6
connection_attempts             = 6
connection_delay                = 1

[protocol.xmlrpc]
address                         = 192.168.70.100:8080
threads                         = 5
user                            = admin
password                        = admin
disable_authentication          = no
realm                           = MySQL Fabric
ssl_ca                          =
ssl_cert                        =
ssl_key                         =

[executor]
executors                       = 5

[logging]
level                           = INFO
url                             = file:///var/log/fabric.log

[sharding]
mysqldump_program               = /usr/bin/mysqldump
mysqlclient_program             = /usr/bin/mysql

[connector]
ttl                             = 1

[failure_tracking]
notifications                   = 300
notification_clients            = 50
notification_interval           = 60
failover_interval               = 1
detections                      = 3
detection_interval              = 6
detection_timeout               = 1
prune_time                      = 3600

[client]
password=

[protocol.mysql]
disable_authentication = no
ssl_cert =
ssl_key =
ssl_ca =
user = admin
address = localhost:32275
password =
