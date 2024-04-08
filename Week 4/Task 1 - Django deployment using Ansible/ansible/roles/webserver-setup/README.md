webserver-setup
=========

This role configures remote Ubuntu machine to have all required python packages for [sample-django](https://github.com/digitalocean/sample-django) project and nginx installed.

Requirements
------------

Modules:
  - ansible.builtin

Role Variables
--------------

None

Dependencies
------------

None

Example Playbook
----------------

- hosts: servers
  roles:
    - webserver-setup

License
-------

BSD

Author Information
------------------