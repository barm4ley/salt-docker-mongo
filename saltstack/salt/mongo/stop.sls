{% from "mongo/map.jinja" import mongo_options as mongo with context %}
{% from "mongo/map.jinja" import mongo_image_options as image with context %}

stop_mongo:
  dockerng.stopped:
    - names:
      - {{ image.name }}

remove_mongo:
  dockerng.absent:
    - names:
      - {{ image.name }}
    - require:
      - dockerng: stop_mongo

{{ mongo.dbpath }}:
  file.absent:
    - require:
      - dockerng: stop_mongo
