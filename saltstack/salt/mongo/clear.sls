{% from "mongo/map.jinja" import mongo_options as mongo with context %}
{% from "mongo/map.jinja" import mongo_image_options as image with context %}

include:
  - mongo.stop

remove_mongo_db_dir:
  file.absent:
    - name: {{ mongo.dbpath }}
    - require:
      - dockerng: remove_mongo


{% if mongo.logpath %}
remove_log_dir:
  file.absent:
    - name: {{ mongo.logpath }}
    - require:
      - dockerng: remove_mongo
{% endif %}
