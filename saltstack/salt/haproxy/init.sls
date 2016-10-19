{% from "haproxy/map.jinja" import haproxy with context %}

include:
  - pip
  - docker


download_haproxy_image:
  dockerng.image_present:
    - name: {{ haproxy.image.name }}:{{ haproxy.image.tag }}
    - require:
      - pip: docker_python_api
