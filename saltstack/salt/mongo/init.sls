{% from "mongo/map.jinja" import mongo_options as mongo with context %}
{% from "mongo/map.jinja" import mongo_image_options as image with context %}

include:
  - pip
  - docker

copy_mongo_config:
  file.managed:
    - name: /etc/mongodb.conf
    - source: salt://mongo/files/mongodb.conf.jinja
    - template: jinja
    - user: {{ mongo.user }}
    - group: {{ mongo.group }}


{% if mongo.replset %}
/etc/mongodb.key:
  file.managed:
    - source: salt://mongo/files/mongodb.key
    - user: {{ mongo.user }}
    - group: {{ mongo.group }}
    - mode: 600
    - require_in:
      - dockerng: copy_mongo_config
{% endif %}


{% if mongo.logpath %}
create_log_dir:
  file.directory:
    - name: {{ mongo.logpath }}
    - user: {{ mongo.user }}
    - group: {{ mongo.group }}
    - require_in:
      - dockerng: copy_mongo_config
{% endif %}


create_mongo_db_dir:
  file.directory:
    - name: {{ mongo.dbpath }}
    - user: {{ mongo.user }}
    - group: {{ mongo.group }}
    - require_in:
      - dockerng: copy_mongo_config


download_mongo_image:
  dockerng.image_present:
    - name: {{ image.name }}:{{ image.tag }}
    - require:
      - pip: docker_python_api


install_pymongo:
  pip.installed:
    - name: pymongo
    - upgrade: True
    - require:
      - cmd: python_pip_update
