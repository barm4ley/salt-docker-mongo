{% from "haproxy/map.jinja" import haproxy with context %}

copy_haproxy_config:
  file.managed:
    - source: salt://haproxy/files/haproxy.cfg.jinja
    - name: {{ haproxy.config_dir }}/haproxy.cfg
    - template: jinja
    - makedirs: True


