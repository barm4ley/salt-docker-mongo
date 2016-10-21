{% from "mongo/map.jinja" import mongo with context %}
{% from "docker/helpers.jinja" import stop_container with context %}

include:
  - mongo.unschedule_backup

{{ stop_container(mongo.image.name) }}
