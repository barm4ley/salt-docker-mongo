{% from "consul/map.jinja" import consul with context %}

include:
  - docker
  - pip
  #- consul.clear

{% if salt.dockerng.exists(consul.image.name) %}


{% if salt.dockerng.state(consul.image.name) == 'running' %}
stop_consul_container:
  dockerng.stopped:
    - names:
      - {{ consul.image.name }}
    - require_in:
      - dockerng: remove_consul_container

{% endif %}

remove_consul_container:
  dockerng.absent:
    - names:
      - {{ consul.image.name }}


{% endif %}
