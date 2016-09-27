{% set replset = salt['pillar.get']('mongo_options:replset', '') %}

/etc/mongodb.conf:
  file.managed:
    - source: salt://mongo/mongodb.conf.jinja
    - template: jinja
    - user: root
    - group: root

{% if replset %}
/etc/mongodb.key:
  file.managed:
    - source: salt://mongo/mongodb.key
    - template: jinja
    - user: root
    - group: root
    - mode: 400
    - require_in:
      - dockerng: run_mongo_container
{% endif %}

download_mongo_image:
  dockerng.image_present:
    - name: 'mongo:latest'
    - require:
      - pip: docker_python_api

run_mongo_container:
  dockerng.running:
    - name: mongo
    - image: mongo:latest
    - hostname: mongo
    - tty: False
    - interactive: False
    - port_bindings:
      - 27017:27017/tcp
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

copy_mongo_replset_setup_script:
  file.managed:
    - name: /opt/apps/mongodb/mongodb_replset_setup.py
    - source: salt://mongo/mongodb_replset_setup.py
    - makedirs: True

#run_mongo_replset_setup_script:
  #cmd.run:
    #- name: python /opt/apps/mongodb/mongodb_replset_setup.py
    #- user: root
    #- require:
      #- file: copy_mongo_replset_setup_script
      #- dockerng: run_mongo_container
