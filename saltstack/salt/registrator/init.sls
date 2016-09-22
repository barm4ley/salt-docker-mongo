download_registrator_image:
  dockerng.image_present:
    - name: 'gliderlabs/registrator:latest'
    - require:
      - pip: docker_python_api

run_registrator_container:
  dockerng.running:
    - name: registrator
    - image: gliderlabs/registrator:latest
    #- hostname: registrator
    - tty: False
    - interactive: False
    - network_mode: host
    - binds:
      - /var/run/docker.sock:/tmp/docker.sock
      #- command: /bin/registrator consul://192.168.50.12:8500
    - command: consul://192.168.50.12:8500
    - dns:
      - 8.8.8.8
      - 8.8.4.4
    - require:
      - dockerng: download_registrator_image
