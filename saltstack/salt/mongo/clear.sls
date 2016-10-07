{% from "mongo/map.jinja" import mongo with context %}

include:
  - mongo.stop

remove_mongo_db_dir:
  file.absent:
    - name: {{ mongo.config.dbpath }}


{% if mongo.config.logpath %}
remove_log_dir:
  file.absent:
    - name: {{ mongo.config.logpath }}
    - require_in:
      - file: remove_mongo_db_dir
    {% if salt.dockerng.exists(mongo.image.name) %}
    - require:
      - dockerng: remove_mongo_container
    {% endif %}

{% endif %}
