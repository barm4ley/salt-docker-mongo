{% from "mongo/map.jinja" import mongo_options as mongo with context %}
{% from "mongo/map.jinja" import mongo_image_options as image with context %}


include:
  - mongo
  - docker


run_mongo_container:
  dockerng.running:
    - name: {{ image.name }}
    - image: {{ image.name }}:{{ image.tag }}
    - hostname: {{ image.name }}
    - port_bindings:
      - 27017:27017/tcp
    - binds:
      - {{ mongo.dbpath }}:{{ mongo.dbpath }}
      - /etc/mongodb.conf:/etc/mongodb.conf:ro
      - /var/log/mongodb:/var/log/mongodb

      {% if mongo.logpath %}
      - {{ mongo.logpath }}:{{ mongo.logpath }}
      {% endif %}

      {% if mongo.replset %}
      - /etc/mongodb.key:/etc/mongodb.key:ro
      {% endif %}

    - cmd: --config /etc/mongodb.conf {% if mongo.replset %} --keyFile /etc/mongodb.key --replSet {{ mongo.replset }} {% endif %}
    - environment:
      - SERVICE_TAGS: {{ grains['nodename'] }}
      - SERVICE_ID: {{ grains['nodename'] }}
    - dns:
      - 8.8.8.8
      - 8.8.4.4
    - require:
      - dockerng: download_mongo_image
      - file: copy_mongo_config
    - watch:
      - file: copy_mongo_config
