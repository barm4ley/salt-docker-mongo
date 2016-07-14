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
    - tty: True
    - interactive: True
    - ports:
      - 27017/tcp
    #- binds:
    #  - /demo/web/site1:/usr/share/nginx/html:ro
    - dns:
      - 8.8.8.8
      - 8.8.4.4
    - require:
      - dockerng: download_mongo_image

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

run_mongo_replset_setup_script:
  cmd.run:
    - name: python /opt/apps/mongodb/mongodb_replset_setup.py
    - user: root
    - require:
      - file: copy_mongo_replset_setup_script
      - dockerng: run_mongo_container
