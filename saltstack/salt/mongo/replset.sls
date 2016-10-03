{% from "mongo/map.jinja" import mongo_options as mongo with context %}
{% from "map.jinja" import ip with context %}


copy_mongo_replset_setup_script:
  file.managed:
    - name: /opt/apps/mongodb/mongodb_replset_setup.py
    - source: salt://mongo/mongodb_replset_setup.py
    - template: jinja
    - makedirs: True


run_mongo_replset_setup_script:
  cmd.run:
    - name: python /opt/apps/mongodb/mongodb_replset_setup.py --ip {{ ip }} --rs-name {{ mongo.replset }} {% if ip != mongo.primary_addr %} --primary {{ mongo.primary_addr }} {% endif %}
    - user: root
    - require:
      - file: copy_mongo_replset_setup_script
    - watch:
      - file: copy_mongo_replset_setup_script
