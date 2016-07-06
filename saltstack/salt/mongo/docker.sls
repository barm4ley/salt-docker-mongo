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
    - port_bindings:
      - 27017:27017/tcp
    - dns:
      - 8.8.8.8
      - 8.8.4.4
    - require:
      - dockerng: download_mongo_image

