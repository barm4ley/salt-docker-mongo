{% from "consul/map.jinja" import consul with context %}

include:
  - docker
  - consul.config
  - consul


run_consul_container:
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
    - environment:
      - SERVICE_IGNORE: 'true'
    - cmd: agent -server -bind=127.0.0.1 -client=0.0.0.0
    - require:
      - dockerng: download_consul_image
    - watch:
      - file: consul_config
      - file: consul_script_config
