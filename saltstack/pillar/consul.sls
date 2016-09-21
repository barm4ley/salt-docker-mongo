consul:
  service: true

  config:
    server: true
    bind_addr: 192.168.50.12
    client_addr: 192.168.50.12

    enable_debug: true

    datacenter: eu

    encrypt: "RIxqpNlOXqtr/j4BgvIMEw=="

    bootstrap_expect: 1
