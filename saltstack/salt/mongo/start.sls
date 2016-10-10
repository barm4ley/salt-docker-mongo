{% from "map.jinja" import sd with context %}
{% from "mongo/map.jinja" import mongo with context %}

include:
  - mongo
  - docker


run_mongo_container:
  dockerng.running:
    - name: {{ mongo.image.name }}
    - image: {{ mongo.image.name }}:{{ mongo.image.tag }}
    - hostname: {{ mongo.image.name }}
    - port_bindings:
      - 27017:27017/tcp
    - binds:
      - {{ mongo.config.dbpath }}:{{ mongo.config.dbpath }}
      - /etc/mongodb.conf:/etc/mongodb.conf:ro
      - /var/log/mongodb:/var/log/mongodb

      {% if mongo.config.logpath %}
      - {{ mongo.config.logpath }}:{{ mongo.config.logpath }}
      {% endif %}

      {% if mongo.config.replset %}
      - /etc/mongodb.key:/etc/mongodb.key:ro
      {% endif %}

    - cmd: --config /etc/mongodb.conf {% if mongo.config.replset %} --keyFile /etc/mongodb.key --replSet {{ mongo.config.replset }} {% endif %}
    - environment:
      - SERVICE_TAGS: {{ sd.service_name }}
      - SERVICE_ID: {{ sd.service_name }}
    - dns:
      - 8.8.8.8
      - 8.8.4.4
    - require:
      - dockerng: download_mongo_image
    - watch:
      - file: copy_mongo_config
