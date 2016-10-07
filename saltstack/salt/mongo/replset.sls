{% from "mongo/map.jinja" import mongo with context %}
{% from "map.jinja" import ip with context %}


copy_setup_replset:
  file.managed:
    - name: {{ mongo.script_path }}/setup_replset.py
    - source: salt://mongo/files/setup_replset.py
    - template: jinja
    - makedirs: True


run_setup_replset:
  cmd.run:
    - name: python {{ mongo.script_path }}/setup_replset.py --ip {{ ip }} --rs-name {{ mongo.config.replset }} {% if ip != mongo.primary_addr %} --primary {{ mongo.primary_addr }} {% endif %}
    - user: root
    - require:
      - file: copy_setup_replset
    - watch:
      - file: copy_setup_replset

remove_setup_replset:
  file.absent:
    - name: {{ mongo.script_path }}/setup_replset.py
    - require:
      - cmd: run_setup_replset
