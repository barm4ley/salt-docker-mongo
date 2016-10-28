{% from "keepalived/map.jinja" import keepalived with context %}

include:
  - pip
  - docker
  - keepalived


insert_ip_virtual_server_module:
  kmod.present:
    - name: ip_vs

copy_keepalived_config:
  file.managed:
    - name: /etc/keepalived.conf
    - source: salt://keepalived/files/keepalived.conf.jinja
    - template: jinja

allow_ip_nonlocal_bind:
  cmd.run:
    - name: echo 1 > /proc/sys/net/ipv4/ip_nonlocal_bind

allow_ip_forward:
  cmd.run:
    - name: echo 1 > /proc/sys/net/ipv4/ip_forward


run_keepalived_container:
  dockerng.running:
    - name: {{ keepalived.image.container_name }}
    - image: {{ keepalived.image.name }}:{{ keepalived.image.tag }}
    #- hostname: {{ keepalived.image.container_name }}-{{ env }}
    - network_mode: host
    - cap_add: NET_ADMIN
    - binds:
      - /etc/keepalived.conf:/etc/keepalived.conf:ro

    - entrypoint: /usr/sbin/keepalived --dont-fork --log-console --log-detail --use-file /etc/keepalived.conf

    - environment:
      - SERVICE_IGNORE: 'true'

    - dns:
      - 8.8.8.8
      - 8.8.4.4
    - require:
      - dockerng: download_keepalived_image
      - kmod: insert_ip_virtual_server_module
      - cmd: allow_ip_nonlocal_bind
      - cmd: allow_ip_forward
    - watch:
      - file: copy_keepalived_config

