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

    #bind_addr: 192.168.50.12
    #client_addr: 192.168.50.12

    bind_addr:
    client_addr:

    #recursors: [10.0.2.3]
    recursors: []
    #ports:
      #dns: 53

    enable_debug: true

    datacenter: eu

    encrypt: "RIxqpNlOXqtr/j4BgvIMEw=="

    bootstrap_expect: 1
