{% from "map.jinja" import sd with context %}
{% from "map.jinja" import env with context %}
{% from "map.jinja" import slack with context %}
{% from "cran/map.jinja" import cran with context %}

include:
  - docker
  - cran
  - cran.web.config


run_cran_container:
  dockerng.running:
    - name: cran
    - image: {{ cran.image.name }}:{{ cran.image.tag }}
    - hostname: cran-{{ env }}.cran
    - restart_policy: always
    - port_bindings:
      - {{ cran.bind_port }}:{{ cran.bind_port }}
    - binds:
      - {{ cran.config_dir }}:{{ cran.config_dir }}
    - dns:
      - {{ sd.address }}
      - 8.8.8.8

    - environment:
      {% for name, val in cran.env.iteritems() %}
      - {{ name }}: "{{ val }}"
      {% endfor %}

      # Container should be registered in SD only in prod environment
      {% if env == 'prod' %}
      - SERVICE_TAGS: {{ sd.service_name }}-web
      - SERVICE_ID: {{ sd.service_name }}-web
      {% else %}
      - SERVICE_IGNORE: 'true'
      {% endif %}

    - cmd: /usr/local/bin/gunicorn cran.wsgi:application --config {{ cran.config_dir }}/gunicorn.conf
    - require:
      - dockerng: download_cran_image
    - watch:
      - file: gunicorn_config


send_cran_started_event:
  event.send:
    - name: docker/cran/{{ env }}/started
    - order: last
    - onchanges:
      - dockerng: run_cran_container

{% if slack.notifications_enabled %}
run_cran_container_slack_message:
  slack.post_message:
    - channel: '#{{ slack.channel }}'
    - from_name: {{ slack.from_name }}
    - api_key: {{ slack.api_key }}
    - message: 'CrAn Web (env: `{{ env }}`) is (re)started on `{{ grains['fqdn'] }}`'
    - onchanges:
      - dockerng: run_cran_container
{% endif %}
