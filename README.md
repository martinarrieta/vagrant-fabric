Requirements
============

Ansible
-------

URL: http://www.ansible.com/

Install: http://docs.ansible.com/intro_installation.html

If you have pip (https://pypi.python.org/pypi) in your system, the following command should be enough
 
    pip install ansible


VirtualBox
----------

URL: http://www.virtualbox.org

Install: https://www.virtualbox.org/wiki/Downloads

Vagrant
-------

URL: http://www.vagrantup.com/

Download: http://www.vagrantup.com/downloads.html 


Installation
============


    git clone https://github.com/martinarrieta/vagrant-fabric 
    vagrant up

Get a coffee and wait until this process finish 
 
Basic commands
==============

Connect to the VM
----------------------

This command will connect you to the server.

    vagrant ssh <vm_name>
 
For example:

    $ vagrant ssh store
    Last login: Wed May  7 16:40:21 2014 from 10.0.2.2
    [vagrant@store ~]$

Destroy a VM
--------------

This command will stop the vm if is running and it will remove the vm files.

    vagrant destroy <vm_name>

For example: 

    $ vagrant destroy node3
    Are you sure you want to destroy the 'node3' VM? [y/N] y
    [node3] Forcing shutdown of VM...
    [node3] Destroying VM and associated drives...
    [node3] Running cleanup tasks for 'ansible' provisioner...
 

Start a VM
--------------

This command will create and start the vm.

    vagrant up <vm_name>

For example: 

    $ vagrant up node3
    Bringing machine 'node3' up with 'virtualbox' provider...
    [node3] Importing base box 'centos65-x86_64-20140116'...
    Progress: 100%
    ...
    PLAY RECAP ********************************************************************
    node3                      : ok=14   changed=11   unreachable=0    failed=0
 
The important one is "failed=0" :)

Provision a VM
--------------

This command will run all the ansible playbooks, the VM must be "UP".

    vagrant provision <vm_name>

For example: 

    $ vagrant provision node3
    [node3] Running provisioner: ansible...
    PLAY [all] ********************************************************************
    ...
    PLAY RECAP ********************************************************************
    node3                      : ok=14   changed=1   unreachable=0    failed=0
 
Again, the important one is "failed=0" :)




