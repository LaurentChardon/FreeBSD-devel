# Package management on developer workstation
Use ansible from a remote machine to remove all installed packages and install base system.
This is useful when the machine is polluted by development packages and needs to be cleaned.

Use
    ansible-playbook -i inventory packages.yml

The file inventory is of the form
    [freebsd_target]
    freebsd.home
    
    [freebsd_target:vars]
    ansible_python_interpreter=/usr/local/bin/python

