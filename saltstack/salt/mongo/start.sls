{% from "map.jinja" import sd with context %}
{% from "map.jinja" import env with context %}
{% from "map.jinja" import slack with context %}
{% from "mongo/map.jinja" import mongo with context %}

include:
  - mongo
  - docker


run_mongo_container:
  dockerng.running:
    - name: {{ mongo.image.container_name }}
    - image: {{ mongo.image.name }}:{{ mongo.image.tag }}
    - hostname: {{ mongo.image.container_name }}-{{ env }}
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

    - cmd: --config /etc/mongodb.conf {% if mongo.config.replset %} {% if mongo.config.auth %} --keyFile /etc/mongodb.key {% endif %} --replSet {{ mongo.config.replset }} {% endif %}

    - environment:
      {% if env == "prod" %}
      - SERVICE_TAGS: {{ sd.service_name }}
      - SERVICE_ID: {{ sd.service_name }}
      {% else %}
      - SERVICE_IGNORE: 'true'
      {% endif %}

    - dns:
      - 8.8.8.8
      - 8.8.4.4
    - require:
      - dockerng: download_mongo_image
    - watch:
      - file: copy_mongo_config


{% if slack.notifications_enabled %}
run_mongo_container_slack_message:
  slack.post_message:
    - channel: '#{{ slack.channel }}'
    - from_name: {{ slack.from_name }}
    - api_key: {{ slack.api_key }}
    - message: 'MongoDB (env: `{{ env }}`) is (re)started on `{{ grains['fqdn'] }}`'
    - onchanges:
      - dockerng: run_mongo_container
{% endif %}
