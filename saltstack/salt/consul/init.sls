{% from "consul/map.jinja" import consul with context %}

include:
  - docker
  - pip


download_consul_image:
  dockerng.image_present:
    - name: {{ consul.image.name }}:{{ consul.image.tag }}
    - require:
      - pip: docker_python_api
