
Ansible Mattermost
=========

This role is a configurable solution for installing Mattermost *only*.

Requirements
------------

None.

Role Variables
--------------

- `mattermost_version`: the version of Mattermost to install.
- `mattermost_db_driver`: the DB driver to use - currently, only 'postgres' is supported.
- `mattermost_db_user`: the user that Mattermost uses to connect to the database.
- `mattermost_db_password`: the password that Mattermost uses to authenticate with the database.
- `mattermost_db_host`: the Mattermost DB host.
- `mattermost_db_port`: the Mattermost DB port.
- `mattermost_db_name`: the name of the database.

Dependencies
------------

None.

Example Playbook
----------------

```yaml
---
- hosts: mattermost
  become: yes
  roles:
    - role: twistedvines.ansible-role-mattermost
```

License
-------

BSD
