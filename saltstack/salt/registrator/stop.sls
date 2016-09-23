stop_registrator:
  dockerng.stopped:
    - names:
      - registrator

remove_registrator:
  dockerng.absent:
    - names:
      - registrator
    - require:
      - dockerng: stop_registrator
