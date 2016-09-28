{% set replset = salt['pillar.get']('mongo_options:replset', '') %}
{% set dbpath = salt['pillar.get']('mongo_options:dbpath', '/data') %}
{% set logpath = salt['pillar.get']('mongo_options:logpath', '') %}

{% set mongo_image_name = salt['pillar.get']('mongo_image_options:name', 'mongo') %}
{% set mongo_image_tag = salt['pillar.get']('mongo_image_options:tag', 'latest') %}

{% set mongo_user = 999 %}
{% set mongo_group = 999 %}


/etc/mongodb.conf:
  file.managed:
    - source: salt://mongo/mongodb.conf.jinja
    - template: jinja
    - user: {{ mongo_user }}
    - group: {{ mongo_group }}


{% if replset %}
/etc/mongodb.key:
  file.managed:
    - source: salt://mongo/mongodb.key
    - template: jinja
    - user: {{ mongo_user }}
    - group: {{ mongo_group }}
    - mode: 600
    - require_in:
      - dockerng: run_mongo_container
{% endif %}


{% if logpath %}
{{ logpath }}:
  file.directory:
    - user: {{ mongo_user }}
    - group: {{ mongo_group }}
    - require_in:
      - dockerng: run_mongo_container
{% endif %}


{{ dbpath }}:
  file.directory:
    - user: {{ mongo_user }}
    - group: {{ mongo_group }}
    - require_in:
      - dockerng: run_mongo_container


download_mongo_image:
  dockerng.image_present:
    - name: {{ mongo_image_name }}:{{ mongo_image_tag }}
    - require:
      - pip: docker_python_api


run_mongo_container:
  dockerng.running:
    - name: mongo
    - image: {{ mongo_image_name }}:{{ mongo_image_tag }}
    - hostname: mongo
    - port_bindings:
      - 27017:27017/tcp
    - binds:
      - {{ dbpath }}:{{ dbpath }}
      {% if logpath %}
      - {{ logpath }}:{{ logpath }}
      {% endif %}
      - /var/log/mongodb:/var/log/mongodb
      - /etc/mongodb.key:/etc/mongodb.key:ro
      - /etc/mongodb.conf:/etc/mongodb.conf:ro
      #- user: root
    - cmd: --config /etc/mongodb.conf
    - environment:
      - SERVICE_TAGS: {{ grains['nodename'] }}
      - SERVICE_ID: {{ grains['nodename'] }}
    - dns:
      - 8.8.8.8
      - 8.8.4.4
    - require:
      - dockerng: download_mongo_image
      - file: /etc/mongodb.conf
    - watch:
      - file: /etc/mongodb.conf

install_pymongo:
  pip.installed:
    - name: pymongo
    - upgrade: True
    - require:
      - cmd: python_pip_update
