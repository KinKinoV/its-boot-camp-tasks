deploy
=========

This role deploys [sample-django](https://github.com/digitalocean/sample-django) project to target remote nodes by:
  1. Configuring environment (disabling default nginx site and enabling proxy pass to django developer server)
  2. Downloading source code from git to specified directory
  3. Changing `manage.py` file to correctly run using `comunity.general.django_manage` module
  4. Making migrations and migrating them to PostgreSQL DB
  5. Starting Django developer server 

Requirements
------------

Modules:
  - `ansible.builtin`
  - `community.general.django_manage`

Role Variables
--------------

Environment:
  - `DATABASE_URL`: 
  - `ALLOWED_HOSTS`:

Variables:
  - db_name:
  - db_user:
  - db_password:
  - django_dir:
  - django_port:

Dependencies
------------

This role should be run AFTER `webservers-setup` and `postgres-setup` roles.

Example Playbook
----------------
```yml
- name: Deploying django and making migrations
  hosts: webservers
  vars_files:
    - common_vars.yml
  environment:
    DATABASE_URL: "postgres://{{ db_user }}:{{ db_password }}@{{ postgres_host }}/{{ db_name }}"
    ALLOWED_HOSTS: "{{ allowed_hosts }}"
  roles:
    - deploy
```

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
