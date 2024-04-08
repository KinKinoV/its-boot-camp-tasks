postgres-setup
=========

This role installs required postgresql package on remote node, creates new database user, database and gives new user all privs on created DB. Also configures postgresql to accept connections from anywhere.

Requirements
------------

Modules:
  - ansible.builtin
  - community.postgresql

Role Variables
--------------

 - db_name: Name for the database to be created
 - db_user: Name of new user
 - db_password: Password for new user
 - postgres_ver: Major PostgreSQL package version number

Dependencies
------------

None

Example Playbook
----------------

- hosts: database
  roles:
    - role: postgres-setup
      db_name: new_db
      db_user: new_user
      db_password: newpassword4newdb
      postgres_ver: 14

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
