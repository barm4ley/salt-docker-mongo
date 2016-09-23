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

