{% from "mongo/map.jinja" import mongo with context %}
{% from "map.jinja" import ip with context %}

##{{ show_full_context() }}


include:
  - mongo


{% if ip == mongo.primary_addr %}

run_mongo_config_container:
  dockerng.running:
    - name: {{ mongo.image.name }}
    - image: {{ mongo.image.name }}:{{ mongo.image.tag }}
    - hostname: {{ mongo.image.name }}
    - port_bindings:
      - 27017:27017/tcp
    - binds:
      - {{ mongo.config.dbpath }}:{{ mongo.config.dbpath }}
      {% if mongo.config.logpath %}
      - {{ mongo.config.logpath }}:{{ mongo.config.logpath }}
      {% endif %}
      - /var/log/mongodb:/var/log/mongodb
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
    - name: {{ mongo.script_path }}/create_superuser.py
    - source: salt://mongo/files/create_superuser.py
    - template: jinja
    - makedirs: True


run_create_superuser:
  cmd.run:
    - name: python {{ mongo.script_path }}/create_superuser.py
    - user: root
    - require:
      - dockerng: run_mongo_config_container
      - file: copy_create_superuser
    - watch:
      - file: copy_create_superuser


remove_create_superuser:
  file.absent:
    - name: {{ mongo.script_path }}/create_superuser.py
    - require:
      - cmd: run_create_superuser


{% for name, params in mongo.creds.users.iteritems() %}
user_{{ name }}:
  mongodb_user.present:
    - user: {{ mongo.creds.superuser.name }}
    - password: {{ mongo.creds.superuser.password }}
    - name: {{ name }}
    - passwd: {{ params.password }}
    - database: {{ params.database }}
    - require:
      - cmd: run_create_superuser
{% endfor %}


stop_mongo_config:
  dockerng.stopped:
    - names:
      - {{ mongo.image.name }}
    - require:
      {% for name, params in mongo.creds.users.iteritems() %}
      - mongodb_user: user_{{ name }}
      {% endfor %}

remove_mongo_config:
  dockerng.absent:
    - names:
      - {{ mongo.image.name }}
    - require:
      - dockerng: stop_mongo_config

{% endif %}

