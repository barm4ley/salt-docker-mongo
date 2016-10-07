{% from "consul/map.jinja" import consul with context %}

consul_config:
  file.managed:
    - source: salt://consul/files/config.json
    - name: {{ consul.config_dir }}/config.json
    - template: jinja
    - makedirs: True
    - user: {{ consul.user }}
    - group: {{ consul.group }}

{% for script in consul.scripts %}
consul_script_install_{{ loop.index }}:
  file.managed:
    - source: {{ script.source }}
    - name: {{ script.name }}
    - template: jinja
    - makedirs: True
    - user: {{ consul.user }}
    - group: {{ consul.group }}
    - mode: 0755
    - require_in:
      - file: consul_config
{% endfor %}

consul_script_config:
  file.managed:
    - source: salt://consul/files/services.json
    - name: {{ consul.config_dir }}/services.json
    - template: jinja
    - makedirs: True
    - user: {{ consul.user }}
    - group: {{ consul.group }}

consul_data_dir:
  file.directory:
    - name: {{ consul.data_dir }}
    - user: {{ consul.user }}
    - group: {{ consul.group }}
    - mode: 0755
    - require_in:
      - dockerng: consul_config
