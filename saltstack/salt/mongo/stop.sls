{% from "mongo/map.jinja" import mongo_options as mongo with context %}
{% from "mongo/map.jinja" import mongo_image_options as image with context %}

#include:
  #- docker
  #- pip

{% if salt.dockerng.exists(image.name) %}

{% if salt.dockerng.state(image.name) == 'running' %}
stop_mongo_container:
  dockerng.stopped:
    - names:
      - {{ image.name }}
    - require_in:
      - dockerng: remove_mongo_container
{% endif %}

remove_mongo_container:
  dockerng.absent:
    - names:
      - {{ image.name }}

{% endif %}
