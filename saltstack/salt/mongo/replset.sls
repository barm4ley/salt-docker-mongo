{% set is_primary = salt['grains.get']('mongo_rs_role', '') %}
{% set primary_addr = '192.168.50.21' %}
{% set replset = salt['pillar.get']('mongo_options:replset', '') %}


copy_mongo_replset_setup_script:
  file.managed:
    - name: /opt/apps/mongodb/mongodb_replset_setup.py
    - source: salt://mongo/mongodb_replset_setup.py
    - makedirs: True

run_mongo_replset_setup_script:
  cmd.run:
    - name: python /opt/apps/mongodb/mongodb_replset_setup.py --ip {{ grains['ip4_interfaces']['eth1'][0] }} --rs-name {{ replset }} {% if not is_primary %} --primary {{ primary_addr }} {% endif %}
    - user: root
    - require:
      - file: copy_mongo_replset_setup_script
      #- dockerng: run_mongo_container
      #- sls: mongo.docker
    - watch:
      - file: copy_mongo_replset_setup_script
