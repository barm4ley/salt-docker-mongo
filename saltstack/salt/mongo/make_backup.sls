{% from "map.jinja" import ip with context %}
{% from "mongo/map.jinja" import mongo with context %}

{% set backup_file = salt.file.join(mongo.backup.dir, mongo.backup.file) %}
{% set last_backup_file = salt.file.join(mongo.backup.dir, mongo.backup.last) %}

include:
  - pip
  - docker

create_mongo_backup_dir:
  file.directory:
    - name: {{ mongo.backup.dir }}
    - user: {{ mongo.user }}
    - group: {{ mongo.group }}
    - makedirs: True

run_mongo_backup_container:
  dockerng.running:
    - name: {{ mongo.image.name }}-backup
    - image: {{ mongo.image.name }}:{{ mongo.image.tag }}
    - interactive: True
    - tty: True
    - binds:
      - {{ mongo.backup.dir }}:{{ mongo.backup.dir }}
    - cmd: mongodump --verbose --host {{ ip }} --port 27017 --username {{ mongo.creds.superuser.name }} --password {{ mongo.creds.superuser.password }} --gzip --archive={{ backup_file }}
    - environment:
      - SERVICE_IGNORE: 'true'
    - require:
      - file: create_mongo_backup_dir

make_last_symlink:
  file.symlink:
    - name: {{ last_backup_file }}
    - target: {{ backup_file }}
    - require:
      - dockerng: run_mongo_backup_container

