{% from "consul_docker/map.jinja" import consul with context %}

include:
  - docker
  - consul_docker.config


download_consul_image:
  dockerng.image_present:
    - name: {{ consul.image.name }}:{{ consul.image.tag }}
    - require:
      - pip: docker_python_api

run_consul_image:
  dockerng.running:
    - name: {{ consul.image.name }}
    - image: {{ consul.image.name }}:{{ consul.image.tag }}
    - hostname: {{ consul.image.name }}
    - port_bindings:
      - 53:8600/tcp
      - 53:8600/udp
      - 8400:8400
      - 8500:8500
    - binds:
      - {{ consul.config_dir }}:/consul/config
      - {{ consul.data_dir }}:/consul/data:rw

    - cmd: agent -server -bind=127.0.0.1 -client=0.0.0.0
    - require:
      - dockerng: download_consul_image
      - file: consul_config
      - file: consul_script_config
    - watch:
      - file: consul_config
      - file: consul_script_config
