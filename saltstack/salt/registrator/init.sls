download_registrator_image:
  dockerng.image_present:
    - name: 'gliderlabs/registrator:latest'
    - require:
      - pip: docker_python_api

run_registrator_container:
  dockerng.running:
    - name: registrator
    - image: gliderlabs/registrator:latest
    - tty: False
    - interactive: False
    - network_mode: host
    - binds:
      - /var/run/docker.sock:/tmp/docker.sock
    - command: consul://{{ pillar['service-discovery']['address'] }}:{{ pillar['service-discovery']['port'] }}
    - dns:
      - 8.8.8.8
      - 8.8.4.4
    - require:
      - dockerng: download_registrator_image
