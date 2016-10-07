{% from "mongo/map.jinja" import mongo with context %}


{% if salt.dockerng.exists(mongo.image.name) %}

{% if salt.dockerng.state(mongo.image.name) == 'running' %}
stop_mongo_container:
  dockerng.stopped:
    - names:
      - {{ mongo.image.name }}
    - require_in:
      - dockerng: remove_mongo_container
{% endif %}

remove_mongo_container:
  dockerng.absent:
    - names:
      - {{ mongo.image.name }}

{% endif %}
