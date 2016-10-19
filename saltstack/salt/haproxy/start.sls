{% from "map.jinja" import sd with context %}
{% from "haproxy/map.jinja" import haproxy with context %}

include:
  - pip
  - docker
  - haproxy
  - haproxy.config


run_haproxy_container:
  dockerng.running:
    - name: haproxy
    - image: {{ haproxy.image.name }}:{{ haproxy.image.tag }}
    - hostname: cran-prod.haproxy
    - restart_policy: always
    - port_bindings:
      - {{ haproxy.bind_port }}:{{ haproxy.bind_port }}
    - binds:
      - {{ haproxy.config_dir }}:{{ haproxy.config_dir }}
      - /dev/log:/dev/log
    - dns:
      - {{ sd.address }}
      - 8.8.8.8

    - environment:
      - SERVICE_TAGS: {{ sd.service_name }}-haproxy
      - SERVICE_ID: {{ sd.service_name }}-haproxy
      - HAPROXY_CONFIG: {{ haproxy.config_dir }}/haproxy.cfg

    #- cmd: haproxy -f {{ haproxy.config_dir }}/haproxy.cfg
    - require:
      - dockerng: download_haproxy_image
    - watch:
      - file: copy_haproxy_config
