{% from "registrator/map.jinja" import registrator_image_options as image with context %}
{% from "map.jinja" import ip with context %}

download_registrator_image:
  dockerng.image_present:
    - name: {{ image.name }}:{{ image.tag }}
    - require:
      - pip: docker_python_api

run_registrator_container:
  dockerng.running:
    - name: {{ image.container_name }}
    - image: {{ image.name }}:{{ image.tag }}
    - hostname: {{ image.container_name }}
    - binds:
      - /var/run/docker.sock:/tmp/docker.sock
    - command: -ip {{ ip }} consul://{{ pillar['service-discovery']['address'] }}:{{ pillar['service-discovery']['port'] }}
    - dns:
      - 8.8.8.8
      - 8.8.4.4
    - require:
      - dockerng: download_registrator_image
