{% from "cran/map.jinja" import cran with context %}

gunicorn_config:
  file.managed:
    - source: salt://cran/web/files/gunicorn.conf.jinja
    - name: {{ cran.config_dir }}/gunicorn.conf
    - template: jinja
    - makedirs: True
