{% from "registrator/map.jinja" import registrator_image_options as image with context %}

stop_registrator:
  dockerng.stopped:
    - names:
      - {{ image.container_name }}

remove_registrator:
  dockerng.absent:
    - names:
      - {{ image.container_name }}
    - require:
      - dockerng: stop_registrator
