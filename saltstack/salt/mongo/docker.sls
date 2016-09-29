{% from "mongo/map.jinja" import mongo_options as mongo with context %}
{% from "mongo/map.jinja" import mongo_image_options as image with context %}


/etc/mongodb.conf:
  file.managed:
    - source: salt://mongo/mongodb.conf.jinja
    - template: jinja
    - user: {{ mongo.user }}
    - group: {{ mongo.group }}


{% if mongo.replset %}
/etc/mongodb.key:
  file.managed:
    - source: salt://mongo/mongodb.key
    - template: jinja
    - user: {{ mongo.user }}
    - group: {{ mongo.group }}
    - mode: 600
    - require_in:
      - dockerng: run_mongo_container
{% endif %}


{% if mongo.logpath %}
{{ mongo.logpath }}:
  file.directory:
    - user: {{ mongo.user }}
    - group: {{ mongo.group }}
    - require_in:
      - dockerng: run_mongo_container
{% endif %}


{{ mongo.dbpath }}:
  file.directory:
    - user: {{ mongo.user }}
    - group: {{ mongo.group }}
    - require_in:
      - dockerng: run_mongo_container


download_mongo_image:
  dockerng.image_present:
    - name: {{ image.name }}:{{ image.tag }}
    - require:
      - pip: docker_python_api


run_mongo_container:
  dockerng.running:
    - name: {{ image.name }}
    - image: {{ image.name }}:{{ image.tag }}
    - hostname: {{ image.name }}
    - port_bindings:
      - 27017:27017/tcp
    - binds:
      - {{ mongo.dbpath }}:{{ mongo.dbpath }}
      {% if mongo.logpath %}
      - {{ mongo.logpath }}:{{ mongo.logpath }}
      {% endif %}
      - /var/log/mongodb:/var/log/mongodb
      - /etc/mongodb.key:/etc/mongodb.key:ro
      - /etc/mongodb.conf:/etc/mongodb.conf:ro
    - cmd: --config /etc/mongodb.conf
    - environment:
      - SERVICE_TAGS: {{ grains['nodename'] }}
      - SERVICE_ID: {{ grains['nodename'] }}
    - dns:
      - 8.8.8.8
      - 8.8.4.4
    - require:
      - dockerng: download_mongo_image
      - file: /etc/mongodb.conf
    - watch:
      - file: /etc/mongodb.conf

install_pymongo:
  pip.installed:
    - name: pymongo
    - upgrade: True
    - require:
      - cmd: python_pip_update
