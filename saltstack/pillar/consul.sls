consul:

  user: 100
  group: 1000
  config_dir: /etc/consul.d
  data_dir: /opt/consul

  image:
    name: consul
    tag: latest


  config:
    server: true

    bind_addr:
    client_addr:

    recursors: []

    enable_debug: true

    encrypt: "RIxqpNlOXqtr/j4BgvIMEw=="

    bootstrap_expect: 1
