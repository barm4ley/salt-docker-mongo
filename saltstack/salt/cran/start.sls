{% from "map.jinja" import sd with context %}
{% from "cran/map.jinja" import cran with context %}

include:
  - docker
  - cran
  - cran.config


run_cran_container:
  dockerng.running:
    - name: cran
    - image: {{ cran.image.name }}:{{ cran.image.tag }}
    - hostname: cran-prod.cran
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

      - SERVICE_TAGS: {{ sd.service_name }}
      - SERVICE_ID: {{ sd.service_name }}

    - cmd: /usr/local/bin/gunicorn cran.wsgi:application --config {{ cran.config_dir }}/gunicorn.conf
    - require:
      - dockerng: download_cran_image
    - watch:
      - file: gunicorn_config


run_cran_fetcher_updater_container:
  dockerng.running:
    - name: fetcher_updater
    - image: {{ cran.image.name }}:{{ cran.image.tag }}
    - hostname: cran-prod.fetcher-updater
    - restart_policy: always
    - dns:
      - {{ sd.address }}
      - 8.8.8.8
    - environment:
      {% for name, val in cran.env.iteritems() %}
      - {{ name }}: "{{ val }}"
      {% endfor %}
    - cmd: python -m cran.manage sync_with_fogbugz

