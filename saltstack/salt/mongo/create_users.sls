{% from "mongo/map.jinja" import mongo_options as mongo with context %}
{% from "mongo/map.jinja" import mongo_image_options as image with context %}
{% from "mongo/map.jinja" import mongo_creds as creds with context %}
{% from "map.jinja" import ip with context %}

##{{ show_full_context() }}


include:
  - mongo


{% if ip == mongo.primary_addr %}

run_mongo_config_container:
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
      #- /etc/mongodb.key:/etc/mongodb.key:ro
      - /etc/mongodb.conf:/etc/mongodb.conf:ro
    - cmd: --config /etc/mongodb.conf
    - environment:
      - SERVICE_IGNORE: 'true'
    - dns:
      - 8.8.8.8
      - 8.8.4.4
    - require:
      - dockerng: download_mongo_image
      - file: copy_mongo_config
    - watch:
      - file: copy_mongo_config


copy_create_superuser:
  file.managed:
    - name: /opt/apps/mongodb/create_superuser.py
    - source: salt://mongo/create_superuser.py
    - template: jinja
    - makedirs: True


run_create_superuser:
  cmd.run:
    - name: python /opt/apps/mongodb/create_superuser.py
    - user: root
    - require:
      - dockerng: run_mongo_config_container
      - file: copy_create_superuser
    - watch:
      - file: copy_create_superuser


remove_create_superuser:
  file.absent:
    - name: /opt/apps/mongodb/create_superuser.py
    - require:
      - cmd: run_create_superuser


{% for name, params in creds.users.iteritems() %}
user_{{ name }}:
  mongodb_user.present:
    - user: {{ creds.superuser.name }}
    - password: {{ creds.superuser.password }}
    - name: {{ name }}
    - passwd: {{ params.password }}
    - database: {{ params.database }}
    - require:
      - cmd: run_create_superuser
{% endfor %}


stop_mongo_config:
  dockerng.stopped:
    - names:
      - {{ image.name }}
    - require:
      {% for name, params in creds.users.iteritems() %}
      - mongodb_user: user_{{ name }}
      {% endfor %}

remove_mongo_config:
  dockerng.absent:
    - names:
      - {{ image.name }}
    - require:
      - dockerng: stop_mongo_config

{% endif %}

