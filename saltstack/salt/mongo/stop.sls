{% from "mongo/map.jinja" import mongo_options as mongo with context %}
{% from "mongo/map.jinja" import mongo_image_options as image with context %}

include:
  - mongo.start

stop_mongo:
  dockerng.stopped:
    - names:
      - {{ image.name }}
    - require:
      - dockerng: run_mongo_container

remove_mongo:
  dockerng.absent:
    - names:
      - {{ image.name }}
    - require:
      - dockerng: stop_mongo
