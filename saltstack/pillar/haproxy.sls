haproxy:
  config_dir: /etc/haproxy

  bind_address: 0.0.0.0
  bind_port: 80

  image:
    name: million12/haproxy
    tag: latest
