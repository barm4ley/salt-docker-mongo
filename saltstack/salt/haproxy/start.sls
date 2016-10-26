{% from "map.jinja" import sd with context %}
{% from "map.jinja" import env with context %}
{% from "map.jinja" import slack with context %}
{% from "haproxy/map.jinja" import haproxy with context %}

include:
  - pip
  - docker
  - haproxy
  - haproxy.config


run_haproxy_container:
  dockerng.running:
    - name: {{ haproxy.image.container_name }}
    - image: {{ haproxy.image.name }}:{{ haproxy.image.tag }}
    - hostname: cran-{{ env }}.haproxy
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
      # Container should be registered in SD only in prod environment
      {% if env == 'prod'%}
      - SERVICE_TAGS: {{ sd.service_name }}-lb
      - SERVICE_ID: {{ sd.service_name }}-lb
      {% else %}
      - SERVICE_IGNORE: 'true'
      {% endif %}

      - HAPROXY_CONFIG: {{ haproxy.config_dir }}/haproxy.cfg

    - require:
      - dockerng: download_haproxy_image
    - watch:
      - file: copy_haproxy_config


{% if slack.notifications_enabled %}
run_haproxy_container_slack_message:
  slack.post_message:
    - channel: '#{{ slack.channel }}'
    - from_name: {{ slack.from_name }}
    - api_key: {{ slack.api_key }}
    - message: 'HAProxy (env: `{{ env }}`) is (re)started on `{{ grains['fqdn'] }}`'
    - onchanges:
      - dockerng: run_haproxy_container
{% endif %}
