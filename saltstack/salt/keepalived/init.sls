{% from "keepalived/map.jinja" import keepalived with context %}

include:
  - pip
  - docker

download_keepalived_image:
  dockerng.image_present:
    - name: {{ keepalived.image.name }}:{{ keepalived.image.tag }}
    - require:
      - pip: docker_python_api
