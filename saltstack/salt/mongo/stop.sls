{% set dbpath = salt['pillar.get']('mongo_options:dbpath', '/data') %}

stop_mongo:
  dockerng.stopped:
    - names:
      - mongo

remove_mongo:
  dockerng.absent:
    - names:
      - mongo
    - require:
      - dockerng: stop_mongo

{{ dbpath }}:
  file.absent:
    - require:
      - dockerng: stop_mongo
